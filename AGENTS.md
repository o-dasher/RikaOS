# AGENTS.md - RikaOS Project Guide

## Project Overview

**RikaOS** is a modular NixOS and Home Manager configuration repository built with **Nix Flakes**. It manages system configurations, dotfiles, themes via Stylix, and secrets via Agenix.

Key components:
- **Flake-based**: keeps configurations reproducible.
- **Modular**: configuration is split across `modules/nixos`, `modules/home`, and `hosts`.
- **Neovim**: managed declaratively through `mnw` (My Neovim Wrapper).

## Critical Flake Workflows

### Git Tracking Is Mandatory

Nix Flakes only see files that are tracked by git. A newly created file is invisible to Nix until it has been added to the git index.

Important:
- Always run `git add` on new or changed files before building or checking.
- If you add a file and Nix reports it as missing, the usual cause is that the file is not tracked yet.

### Test Changes Before Applying

Before applying changes, verify that the flake still evaluates correctly.

```bash
git add .
nix flake check
```

Use `nix flake check --no-build` if you only want evaluation without running builds.

## Apply Changes Safely

Do not use `colmena`, `nh`, or `nixos-rebuild switch` from this public repository. It does not contain everything required to apply system changes as intended, including the necessary private Agenix material.

Use Home Manager instead:

```bash
git add .
home-manager switch --flake .
```

For a specific user:

```bash
git add .
home-manager switch --flake .#username
```

## Repository Structure

- `flake.nix`: flake entry point.
- `hosts/<hostname>`: machine-specific configuration.
- `modules/nixos`: reusable NixOS modules.
- `modules/home`: reusable Home Manager modules.
- `dotfiles`: raw dotfiles such as Neovim Lua config.
