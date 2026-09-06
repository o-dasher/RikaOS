# RikaOS

Personal NixOS and Home Manager configurations for my desktop and laptop, managed with Nix Flakes and Lix.

## Overview

- **Modules**: System and user configurations split into reusable `features` and `profiles` across `modules/nixos` and `modules/home`.
- **Nix implementation**: Evaluated using [Lix](https://lix.systems).
- **Desktop**: [Hyprland](https://hyprland.org/) configured with Lua (`dotfiles/hypr/`).
- **Terminal & Shell**: [Ghostty](https://ghostty.org/) with [Fish](https://fishshell.com/) and [Starship](https://starship.rs/).
- **Editor**: Neovim managed via [`mnw`](https://github.com/Gerg-L/mnw) with Lua config in `dotfiles/nvim/` (and a dev subflake in `flakes/neovim`).
- **Theming**: System-wide theming handled by [Stylix](https://github.com/nix-community/stylix).

## Hosts

| Host | Type | Users | Notes |
|---|---|---|---|
| `hinamizawa` | Desktop | `rika`, `satoko` | AMD GPU, Limine Secure Boot + LUKS, Btrfs, Sunshine, Steam. |
| `gensokyo` | Laptop | `thiago` | Power management via TLP, Tailscale, automounted `/mnt/data`, Hyprland. |

## Usage & Testing

### First Build (with Binary Caches)

When bootstrapping or testing against these configurations, pass the substituters and keys explicitly to avoid building from source:

```bash
nix build .#nixosConfigurations.hostname.config.system.build.toplevel \
  --option extra-substituters "https://cache.nixos.org https://nix-community.cachix.org https://hercules-ci.cachix.org https://cache.numtide.com https://hyprland.cachix.org" \
  --option extra-trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0= niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g= hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
```
*Replace `hostname` with `hinamizawa` or `gensokyo`.*

### Building Configurations

**Build a system toplevel:**
```bash
nix build .#nixosConfigurations.hostname.config.system.build.toplevel
```

**Build Home Manager activation package:**
```bash
nix build .#homeConfigurations."username@hostname".activationPackage
```
*Available user configurations: `rika@hinamizawa`, `satoko@hinamizawa`, `thiago@gensokyo`.*

## Development & Tooling

- **Dev Shell**: Enter an environment with language servers and formatters:
  ```bash
  nix develop
  ```
  *Includes `nixfmt`, `nixfmt-tree`, `stylua`, `lua-language-server`, `nixd`, `nil`, and `statix`.*

- **Evaluation check**:
  ```bash
  nix flake check --no-build
  ```

- **Standalone Neovim**:
  ```bash
  nix run ./flakes/neovim#dev
  ```

## Repository Structure

| Path | Description |
|---|---|
| `flake.nix` | Flake entry point defining inputs, outputs, Lix packages, NixOS systems, and Colmena. |
| `hosts/` | Machine-specific configurations (`hinamizawa`, `gensokyo`) and user entries. |
| `modules/nixos/` | Reusable NixOS system modules (`features/` and `profiles/`). |
| `modules/home/` | Reusable Home Manager modules (`features/` and `profiles/`). |
| `modules/lib/` | Shared utility library (`theme.nix`, `utils.nix`, Tailwind helper, symlink utilities). |
| `dotfiles/` | Out-of-store configuration files (Lua Hyprland setup, Neovim, IdeaVim). |
| `flakes/neovim/` | Standalone `mnw` Neovim wrapper package and devMode flake. |
| `assets/` | Wallpapers, OpenRGB profiles, QMK layouts, and ASCII artwork. |
| `_sources/` & `nvfetcher.toml` | Package tracking specifications and generated sources via `nvfetcher`. |
| `AGENTS.md` | Guide and development instructions for AI agents and contributors. |
