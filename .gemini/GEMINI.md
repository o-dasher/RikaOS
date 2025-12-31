# GEMINI.md - RikaOS Project Guide

## Project Overview

**RikaOS** is a modular NixOS and home-manager configuration repository using **Nix Flakes**. It manages system configurations, dotfiles, themes (Stylix), and secrets (Agenix).

Key Components:
- **Flake-based**: Ensures reproducibility.
- **Modular**: configurations split into `modules/nixos`, `modules/home`, and `hosts`.
- **Neovim**: Managed declaratively via `mnw` (My Neovim Wrapper).

## ⚠️ Critical Flake Workflows

### 1. Git Tracking is Mandatory
Nix Flakes **ONLY** see files that are tracked by git. If you add a new file, it is **invisible** to Nix until you add it to the git staging area.

> [!IMPORTANT]
> **ALWAYS run `git add .` (or specific files) before building or checking.**
>
> If you create a new file and get "file not found" errors during build, you likely forgot to `git add` it.

### 2. Testing Changes
Before applying changes to your system, it is best practice to check if the flake evaluates correctly.

```bash
# Verify the configuration validity
git add .
nix flake check
```
*Note: `nix flake check` builds checks defined in the flake. Use `--no-build` if you only want to verify evaluation.*

## Building and Switching

### NixOS System
To apply the configuration to the current host (must match a hostname in `flake.nix` like `gensokyo` or `hinamizawa`):

```bash
git add .
sudo nixos-rebuild switch --flake .
# OR for a specific host
sudo nixos-rebuild switch --flake .#hostname
```

### Home-Manager
To apply user-specific configurations (must match a username in `flake.nix` like `rika` or `satoko`):

```bash
git add .
home-manager switch --flake .
# OR for a specific user
home-manager switch --flake .#username
```

## Structure
- `flake.nix`: Entry point.
- `hosts/<hostname>`: Machine-specific configs.
- `modules/nixos`: Reusable system modules.
- `modules/home`: Reusable home-manager modules.
- `dotfiles`: Raw dotfiles (e.g. nvim lua config).
