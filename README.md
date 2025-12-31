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
