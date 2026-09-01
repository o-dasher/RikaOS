# RikaOS
Welcome to my personal NixOS and Home Manager configuration repository. This setup manages my systems, applications, themes, and development environments in a reproducible, declarative way using Nix Flakes.

## Overview

- **NixOS & Home Manager**: Managed via structured modules in `modules/nixos` and `modules/home`.
- **Theming**: System-wide theming handled by `stylix`.
- **Neovim**: Declarative configuration using the `mnw` wrapper.
- **Secrets**: Encrypted and managed with `agenix`.

### 1. Clone & Prepare
```bash
git clone https://github.com/o-dasher/RikaOS.git ~/.config
cd ~/.config
```

### 2. Installation
**NixOS System:**
```bash
sudo nixos-rebuild switch --flake .#hostname
```
*Replace `hostname` with a defined host (e.g. `gensokyo`, `hinamizawa`).*

**First Build (with Binary Caches):**
When building for the first time before caches are configured on the system, pass substituters and public keys explicitly to avoid building from source:
```bash
sudo nixos-rebuild switch --flake .#hostname \
  --option extra-substituters "https://cache.nixos.org https://nix-community.cachix.org https://hercules-ci.cachix.org https://cache.numtide.com https://hyprland.cachix.org" \
  --option extra-trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0= niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g= hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
```

**Home Manager (User only):**
```bash
home-manager switch --flake .#username
```
*Replace `username` with a defined user (e.g. `rika`, `satoko`, `thiago`).*

## File Structure

| Path | Description |
|------|-------------|
| `flake.nix` | Entry point defining inputs, outputs, and systems. |
| `hosts/` | Machine-specific configurations (hardware & roles). |
| `modules/nixos/` | Reusable system modules (features, services). |
| `modules/home/` | Reusable home-manager modules (programs, themes). |
| `dotfiles/` | Raw configuration files (e.g., Neovim Lua config). |
