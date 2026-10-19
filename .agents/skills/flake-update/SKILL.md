---
name: flake-update
description: >-
  Update Nix flake inputs, resolve evaluation or build breakages across all hosts
  and users, manage multi-nixpkgs channels (nixos-unstable -> unstable-small ->
  nixpkgs-master -> stable) when pinpoint overrides are required, prune obsolete
  inputs when upstream catches up, and run until all systems and home
  configurations compile cleanly under /goal. Use when the user asks to update
  the flake, update dependencies, update nixpkgs, or resolve flake update breakages.
---

# Flake Update & Automated Breakage Resolution

This skill guides long-running, autonomous updates of Nix Flake inputs across multi-host NixOS systems and Home Manager user environments. It enforces a goal-oriented workflow (`/goal`) that systematically isolates and repairs upstream breakages, evaluates channel fallbacks following a strict freshness priority, prunes redundant flake inputs, and only concludes once every host system and user generation evaluates and compiles cleanly.

---

## Core Philosophy & Operating Rules

1. **Goal-Driven Persistence (`/goal`)**:
   - This task operates under `/goal` mode. Do not stop upon encountering an evaluation error or compilation failure.
   - Formulate hypotheses, diagnose upstream changes, apply the minimal necessary adaptation, and re-verify until 100% of the build matrix passes.
   - Only declare completion with `<!-- GOAL_COMPLETE -->` after all verification targets succeed and atomic commits are recorded.

2. **Safety & Host Protection (CRITICAL)**:
   - **NEVER switch configuration on the host machine.**
   - Do NOT run `nixos-rebuild switch`, `home-manager switch`, `nh os switch`, `nh home switch`, `colmena apply`, or any command that activates configuration on this machine.
   - Verify strictly through dry-run builds (`nix build ... --dry-run`) or offline evaluation (`nix flake check --no-build`).

3. **Sequential Channel Fallback Hierarchy (`nixos-unstable` -> `unstable-small` -> `nixpkgs-master` -> `stable`)**:
   - Everything compiles against **Level 1 (`nixos-unstable`)** by default.
   - We **only ever descend to levels 2, 3, or 4 if we cannot get a proper compilation or if something is broken**, traversing each level in strict sequential order:
     - **Level 1: `nixos-unstable`** (`github:NixOS/nixpkgs/nixos-unstable`) — **[Default / Primary Target]**: The primary baseline for the entire flake. Everything must compile here unless an unresolvable breakage forces a descent.
     - **Level 2: `unstable-small`** (`github:NixOS/nixpkgs/nixos-unstable-small`) — **[First Fallback]**: Descended to ONLY if Level 1 fails to compile or is broken. Tests if the fast-rolling channel provides a working compilation.
     - **Level 3: `nixpkgs-master`** (`github:NixOS/nixpkgs/master`) — **[Second Fallback]**: Descended to ONLY if Level 2 ALSO fails to compile or is broken. Tests if upstream git master compiles cleanly.
     - **Level 4: `stable`** (`github:NixOS/nixpkgs/nixos-26.05` or current stable) — **[Final Fallback]**: Descended to ONLY as a last resort if Levels 1, 2, AND 3 all fail to compile or function properly.
   - **Upward Ascension & Pruning**:
     Whenever a secondary override exists at Level 2, 3, or 4, always test traversing back UP towards Level 1. If Level 1 compiles cleanly, immediately drop the override, remove the secondary input from `flake.nix`, and prune `flake.lock`.

---

## Verification Matrix

Every update must pass dry-run evaluation for the entire matrix of flake targets:

### 1. Discover and Verify Host Systems (NixOS Toplevel)
Dynamically query and dry-run build every NixOS host defined in the flake:
```bash
for host in $(nix eval .#nixosConfigurations --apply builtins.attrNames --json | jq -r '.[]'); do
  nix build ".#nixosConfigurations.${host}.config.system.build.toplevel" --dry-run
done
```

### 2. Discover and Verify User Environments (Home Manager Activation Packages)
Dynamically query and dry-run build every Home Manager user generation defined in the flake:
```bash
for target in $(nix eval .#homeConfigurations --apply builtins.attrNames --json | jq -r '.[]'); do
  nix build ".#homeConfigurations.\"${target}\".activationPackage" --dry-run
done
```

### 3. Code Hygiene & Flake Sanity
```bash
nix fmt
nix flake check --no-build
```

---

## Step-by-Step Workflow

### Step 1: Inspect Initial State & Branch Hygiene
1. Verify working directory is clean:
   ```bash
   git status
   ```
2. Inspect current `flake.nix` inputs and check which inputs currently exist in `flake.lock`.
3. Note any existing secondary inputs or overrides currently in `flake.nix` (e.g. pinned packages or custom overlays).

---

### Step 2: Execute Flake Update
1. Update flake inputs using `BypassSandbox: true` (network access required to pull git commits and channel revisions):
   ```bash
   # Full update:
   nix flake update

   # Or targeted update (e.g. updating specific inputs):
   nix flake update nixpkgs home-manager
   ```
2. Stage the updated lockfile:
   ```bash
   git add flake.lock
   ```

---

### Step 3: Run the Verification Matrix
Run dry-run checks against all discovered targets in the verification matrix.
- If all targets succeed immediately: proceed to **Step 5 (Promotion & Pruning Audit)**.
- If any target fails: capture the exact failure log and proceed to **Step 4 (Breakage Triage & Remediation)**.

---

### Step 4: Breakage Triage & Remediation Playbook

Categorize the failure into one of the following archetypes:

#### Archetype A: Option Renames & Deprecations
*Symptom*: `error: The option ... no longer has any effect; please remove it. Use ... instead.` or `error: undefined option ...`
- **Action**:
  1. Inspect the upstream release notes or nixpkgs/home-manager commit introducing the change.
  2. Update the option path or structure across `modules/nixos/` or `modules/home/`.
  3. Prefer modern structured settings (e.g., `services.<svc>.settings.<Section>` over legacy raw string `extraConfig`).
  4. Flatten single-child attribute sets where appropriate.

#### Archetype B: Package Compilation Failure or Breakage on Primary Channel
*Symptom*: A package fails evaluation, fails to compile, or has an upstream bug on `nixos-unstable`.
- **Action**:
  1. Check if a simple in-tree patch or override fixes the compilation on `nixos-unstable` (e.g. `pkg.overrideAttrs`).
  2. If an external channel override is strictly necessary, descend the hierarchy level by level until a working compilation is achieved:
     - **Step 1 — Descend to Level 2 (`unstable-small`)**:
       Test building the package against `github:NixOS/nixpkgs/nixos-unstable-small`. If it compiles cleanly, add input `nixpkgs-unstable-small` and inherit from it. Stop here.
     - **Step 2 — Descend to Level 3 (`nixpkgs-master`)**:
       If Level 2 ALSO fails to compile or is broken, test building against `github:NixOS/nixpkgs/master`. If it compiles cleanly, add input `nixpkgs-master` and inherit from it. Stop here.
     - **Step 3 — Descend to Level 4 (`stable`)**:
       Only if Levels 1, 2, and 3 all fail to compile or function properly, fall back to the current stable release (`github:NixOS/nixpkgs/nixos-26.05`).
  3. Scope the secondary input strictly to the broken package in the package overlay or host module:
     ```nix
     inherit (mkPkgs system inputs.nixpkgs-<tier> [ ]) brokenPackage;
     ```
  4. Document which levels were tested and why the specific tier was chosen.

#### Archetype C: Compositors, Graphical Drivers & Core Library ABI Mismatches
*Symptom*: Graphical session crashes, buffer allocation/stutter, Wayland dmabuf negotiation failures, or `GLIBC_X.XX not found` when loading graphics drivers or desktop applications.
- **Action**:
  1. Ensure external compositor, desktop, or window manager flakes (and their Mesa / graphics dependencies) follow or align with the system's primary `nixpkgs` input (e.g., `inputs.<compositor-flake>.inputs.nixpkgs.follows = "nixpkgs";`).
  2. Prevent glibc forward-incompatibility: never let a driver in `/run/opengl-driver` depend on a newer glibc than the host binaries dlopening it.
  3. Ensure buffer modifier negotiation and Wayland protocol versions match across compositor and driver components.

---

### Step 5: Secondary Input Audit (Ascension & Pruning)

Whenever `flake.nix` contains secondary channel inputs (Level 2 `unstable-small`, Level 3 `nixpkgs-master`, or Level 4 `stable`):
1. **Upward Ascension Test**:
   Always test ascending back towards Level 1:
   - **First, test Level 1 (`nixos-unstable`)**: Does the package now compile cleanly on the primary channel?
     - **If YES**: Delete the override from `pkgsFor`, remove the secondary input from `inputs` and `outputs` in `flake.nix`, update `flake.lock`, and stage the files. You're done!
     - **If NO**: Proceed to test the next highest level.
   - **If currently on Level 3 or 4, test Level 2 (`unstable-small`)**: Does it compile on `unstable-small`?
     - **If YES**: Promote to Level 2 and prune the lower-level input.
     - **If NO**: Proceed.
   - **If currently on Level 4, test Level 3 (`master`)**: Does it compile on `master`?
     - **If YES**: Promote to Level 3 and prune the Level 4 input.
     - **If NO**: Keep Level 4 until the next update.

---

### Step 6: Formatting, Pre-commit & Atomic Commit

1. Format all Nix and Lua files:
   ```bash
   nix fmt
   ```
2. Run pre-commit checks:
   ```bash
   git add <modified-files>
   nix develop -c pre-commit run
   ```
3. Inspect staged changes:
   ```bash
   git status
   git diff --cached --stat
   ```
4. Create an atomic commit following Conventional Commits (e.g. `feat(flake): update inputs and adapt to upstream changes`).
5. Only when all tests pass, output `<!-- GOAL_COMPLETE -->`.
