# AGENTS.md - RikaOS Project Guide

## Project Overview

**RikaOS** is a modular NixOS and Home Manager configuration repository built with **Nix Flakes** and **Lix** (the modern Nix implementation). It manages system configurations, dotfiles, themes via Stylix, and secrets via a two-tier Agenix architecture.

Key components:
- **Flake-based & Lix**: Fully reproducible builds using Lix (`pkgs.lixPackageSets.git`) as the package set and runtime evaluator across all systems.
- **Modular Design**: Separated into granular `features` and high-level `profiles` across `modules/nixos` and `modules/home`.
- **Hyprland in Lua**: Hyprland configuration is written and managed entirely in **Lua** (`dotfiles/hypr/`), utilizing custom Lua bindings rather than traditional `.conf` files.
- **Neovim via `mnw`**: Declarative Neovim wrapper (`flakes/neovim`) with out-of-store Lua configurations for rapid development and testing.
- **Two-tier Repository Model**: The public repository (`/shared/.config/public`) is open-source and self-contained; sensitive Agenix secrets and deployment keys live in the private repository (`/shared/.config/private`).

---

## Agent Git & Commit Guidelines

### 1. Always Commit Changes
Whenever you make a functional change, bugfix, refactor, or documentation update and verify it, you **must create a git commit**. Do not leave unstaged or uncommitted working trees at the end of a task.

### 2. Prefer Amending for Follow-up Fixes
If you are fixing an issue caused by your previous commit, addressing review feedback, or making a minor polish/typo adjustment to the immediate previous commit, **prefer amending the previous commit** (`git commit --amend` or `git commit --amend --no-edit`) rather than creating trivial "fix typo" or "fix lint" commits.

### 3. Clear Commit Messages
Follow conventional commit style where appropriate:
- `feat(...)`: New feature or configuration option
- `fix(...)`: Bug fix or configuration correction
- `refactor(...)`: Code reorganization or cleanup without behavior changes
- `docs(...)`: Documentation updates (e.g. `AGENTS.md`, `README.md`)
- `style(...)`: Formatting or option description normalization

---

## Critical Flake Workflows

### Git Tracking Is Mandatory

Nix Flakes only see files that are tracked by Git. Any newly created file is completely invisible to Nix until added to the Git staging index.

> [!IMPORTANT]
> Always run `git add` on new or modified files before running `nix flake check`, building, or dry-running configurations.

### Test Changes Before Applying

Always verify flake evaluation before proposing or committing major modifications:

```bash
git add .
nix flake check --no-build
```

*(Note: A warning about unknown flake output `'colmena'` is expected and harmless, as Colmena uses a custom flake output schema).*

To verify building a specific host system toplevel:
```bash
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
```

To verify a specific Home Manager activation package:
```bash
nix build .#homeConfigurations."<username>@<hostname>".activationPackage
```

### Keep Binary Cache Commands in README Synchronized

Whenever binary caches (`nixCaches.extra-substituters` or `nixCaches.extra-trusted-public-keys`) in `flake.nix` are added, removed, or modified, **always update the first-build command under Installation in `README.md`** so the flags match identically.

---

## Applying Changes Safely

> [!CAUTION]
> ### NEVER Switch Configuration on the Host Machine
> **Never switch, apply, or activate configurations directly on the host machine.**
> Under no circumstances should you run `nixos-rebuild switch`, `home-manager switch`, `nh os switch`, `nh home switch`, `colmena apply`, or any command that activates or applies configuration changes to this computer.
>
> At most, only perform **dry runs** or **build checks** (e.g. `nixos-rebuild dry-run`, `nh os test --dry`, `home-manager switch -n`, `home-manager build`, or `nix build`).

### Safe Verification & Dry Runs

Configurations should only ever be verified via dry runs or builds, never switched on this computer:

```bash
# Home Manager dry run (inspect actions without switching):
home-manager switch --flake .#<username> -n

# Or build the Home Manager generation without activating:
home-manager build --flake .#<username>
# Or specifying host target:
home-manager build --flake .#<username>@<hostname>

# NixOS dry run:
nixos-rebuild dry-run --flake .#<hostname>
```

Available user targets:
- `rika` or `rika@hinamizawa`
- `satoko` or `satoko@hinamizawa`
- `thiago` or `thiago@gensokyo`

---

## Repository Structure

```
├── flake.nix                # Flake entry point (Lix, inputs, NixOS/HM configs, Colmena)
├── flake.lock               # Pinned input locks
├── hosts/                   # Machine-specific configurations
│   ├── hinamizawa/          # Workstation (AMD GPU, Limine Secure Boot, LUKS, Btrfs, BitLocker)
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── users/           # User configurations for rika and satoko
│   └── gensokyo/            # Laptop (TLP, Tailscale, automounted /mnt/data)
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── users/           # User configuration for thiago
├── modules/
│   ├── nixos/               # NixOS modules
│   │   ├── features/        # Granular system capabilities (audio, boot, core, filesystem, etc.)
│   │   └── profiles/        # High-level system roles (core, desktop, secure-server)
│   ├── home/                # Home Manager modules
│   │   ├── features/        # Granular user capabilities (cli, desktop, editors, gaming, etc.)
│   │   └── profiles/        # High-level user profiles (browser, dev, gaming, multimedia, etc.)
│   └── lib/                 # Shared helper libraries
│       ├── utils.nix        # rika.utils (idleTimers, symlink helpers, autostart, tailwind)
│       └── theme.nix        # Stylix theme definitions & base16 paletting
├── dotfiles/                # Out-of-store configuration files symlinked via rika.utils
│   ├── hypr/                # Hyprland Lua configuration (init, binds, config, monitors, rules)
│   ├── nvim/                # Declarative Neovim configuration files
│   └── ideavim/             # IdeaVim configuration
├── flakes/
│   └── neovim/              # Standalone mnw-wrapped Neovim subflake with devMode
├── assets/                  # Wallpapers, OpenRGB profiles, QMK layouts, Ascii art
├── _sources/                # nvfetcher generated sources
├── nvfetcher.toml           # Package version tracking (e.g. Minecraft Fabric mods)
├── README.md                # Public user-facing documentation
└── AGENTS.md                # Agent instructions & development workflows
```

---

## Coding Conventions & Key Patterns

- **Lua for Hyprland**: Never write standard `hyprland.conf` directives. Hyprland is configured in Lua (`dotfiles/hypr/`) using the `hl` Lua table API (`hl.bind`, `hl.config`, `hl.window_rule`, `hl.dsp`).
- **Selective Symlinks**: Use `rika.utils.xdgConfigSelectiveSymLink` or `rika.utils.selectiveSymLink` for dotfiles so edits take effect immediately without requiring full activation rebuilds.
- **Stylix Theming**: Theme palettes are generated and propagated through `modules/lib/theme.nix`.
- **Code Formatting**: The flake devShell (`nix develop`) provides `nixfmt`, `stylua`, `nil`, and `statix`. Maintain consistent formatting across Nix and Lua code.

