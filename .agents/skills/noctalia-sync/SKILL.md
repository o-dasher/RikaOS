---
name: noctalia-sync
description: >-
  Sync imperative Noctalia shell changes into the declarative Home Manager
  module (modules/home/features/desktop/wayland/noctalia.nix). Use when the user
  asks to sync, import, or persist imperative Noctalia GUI settings into Nix.
---

# Noctalia Imperative-to-Declarative Sync

Use this workflow to sync settings changed imperatively in the Noctalia Settings GUI into [`modules/home/features/desktop/wayland/noctalia.nix`](file:///shared/.config/public/modules/home/features/desktop/wayland/noctalia.nix).

## Workflow

### 1. Ensure Config Export Exists in `~/Downloads`

1. Check whether `~/Downloads/noctalia-config.toml` exists.
2. If it does not exist (or if the user has not exported their latest changes yet), prompt the user to export their current configuration from Noctalia (**Settings → Config → Export**) to `~/Downloads/noctalia-config.toml` and wait for confirmation before proceeding.

### 2. Back Up Current Imperative State

Before making any edits, back up `~/.local/state/noctalia/settings.toml` (if present) and `~/Downloads/noctalia-config.toml` into the conversation's scratch directory (`<appDataDir>/brain/<conversation-id>/scratch/settings.toml.bak`) using `view_file` and `write_to_file`.

### 3. Sync Settings into `noctalia.nix`

Compare `~/Downloads/noctalia-config.toml` (and `~/.local/state/noctalia/settings.toml`) against [`modules/home/features/desktop/wayland/noctalia.nix`](file:///shared/.config/public/modules/home/features/desktop/wayland/noctalia.nix) and update `programs.noctalia.settings`:

- **Preserve Nix abstractions and host conditionals**:
  - Replace float-serialized Stylix desktop opacity (`0.59999999999999998` / `0.60000002384185791`) with `config.stylix.opacity.desktop`.
  - Round 32-bit float serialization artifacts to clean decimals (e.g., `0.95999998226761818` → `0.96`, `0.34999999999999998` → `0.35`).
  - Keep `gpu_usage` and `gpu_temp` widget definitions and capsule group `members` guarded by `lib.optionals hasAmdgpu` / `lib.optionalAttrs hasAmdgpu`.
  - Keep `battery` widget definitions and capsule group `members` guarded by `lib.optionals cfg.laptop.enable` / `lib.optionalAttrs cfg.laptop.enable`.
  - Use `monoFont` (`font_family = config.stylix.fonts.monospace.name`) on `sysmon` widgets.
  - Keep `idleTimers` (`idleTimers.lock`, `idleTimers.dpms`, `idleTimers.suspend`) in `idle.behavior`.
- **Capsule groups (`bar.default.capsule_group`)**:
  - Only include `capsule_group` entries whose `id` is referenced as `"group:<id>"` in `bar.default.{start,center,end}` (drop orphaned groups left behind by GUI edits).
  - Use the `mkCapsuleGroup` helper for shared group styling (`enabled`, `accordion`, `accordion_direction`, `border`, `fill`, `opacity`, `padding`).
- **Omit Stylix-managed and runtime-seeded keys**:
  - Do not copy keys automatically injected by Stylix (`[theme]`, `[wallpaper.default]`, `shell.font_family`, `notification.background_opacity`, `osd.background_opacity`, `dock.background_opacity`).
  - Do not copy disabled monitor-specific runtime seeds such as `[lockscreen_widgets]` when `lockscreen_widgets.enabled = false`.

### 4. Validate and Commit

1. Stage the file explicitly:
   ```bash
   git add modules/home/features/desktop/wayland/noctalia.nix
   ```
2. Build the generated `noctalia/config.toml` derivation and inspect it with `view_file` to verify 1:1 parity with `~/Downloads/noctalia-config.toml`:
   ```bash
   nix build '.#nixosConfigurations.hinamizawa.config.home-manager.users.rika.xdg.configFile."noctalia/config.toml".source' --no-link --print-out-paths
   ```
3. Run formatting, lints, and flake checks:
   ```bash
   nix develop -c pre-commit run
   nix flake check --no-build
   ```
4. Create an atomic commit (never run `nixos-rebuild switch` or `home-manager switch`).
