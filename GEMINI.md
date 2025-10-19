# GEMINI.md

## Project Overview

This repository contains the personal NixOS and home-manager configurations for managing the user's systems. It uses Nix Flakes to ensure reproducibility and has a modular structure for organizing different aspects of the configuration.

The project, named "RikaOS", sets up applications, themes, and development environments across multiple machines. It leverages `home-manager` for user-specific configurations and `stylix` for theming. Secrets are managed using `agenix`.

The Neovim configuration is a key part of this repository. It is managed using the `mnw` (My Neovim Wrapper) flake, which allows for a declarative configuration of plugins and LSPs within Nix.

## Building and Running

This is a NixOS configuration repository. To apply the configuration to a NixOS machine, you would typically use the `nixos-rebuild` command with a specific flake output.

**Building a NixOS system:**

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Replace `<hostname>` with one of the defined hosts in `flake.nix` (e.g., `gensokyo`, `hinamizawa`).

**Applying a home-manager configuration:**

```bash
home-manager switch --flake .#<username>
```

Replace `<username>` with one of the defined user profiles in `flake.nix` (e.g., `thiago`, `rika`, `satoko`).

Don't forget that for rebuilding to work, if files where changed you need to add then to git stage. So do `git add .` before a rebuild takes place.

**Development Shell:**

The repository provides a development shell with formatting tools. To use it, run:

```bash
nix develop
```

## Development Conventions

The configuration is highly modular, with different concerns separated into different files and directories.

*   **NixOS Modules:** Located in `nixos/modules`, these are reusable modules for configuring NixOS systems.
*   **Home-manager Modules:** Located in `home/modules`, these are reusable modules for configuring user environments with home-manager.
*   **Host Configurations:** Each NixOS host has its own directory in `nixos/hosts`, containing its `configuration.nix` and `hardware-configuration.nix`.
*   **User Profiles:** User-specific configurations are located in `nixos/hosts/<hostname>/users/<username>`.
*   **Theming:** Theming is handled by `stylix`, with custom themes defined in `home/modules/theme`.
*   **Neovim:** The Neovim configuration is managed declaratively using the `mnw` flake, with the configuration defined in `home/modules/applications/neovim/default.nix`. The actual Lua configuration files are in `dotfiles/nvim`.

## Key Files

*   `flake.nix`: The entry point of the configuration. It defines the flake's inputs, outputs, and overall structure.
*   `README.md`: The project's README file, containing a brief overview and instructions.
*   `nixos/hosts/`: This directory contains the configurations for each individual NixOS machine.
*   `home/modules/`: This directory contains the modularized home-manager configurations for different applications and tools.
*   `dotfiles/`: This directory contains dotfiles that are managed by the Nix configuration, such as the Neovim configuration.
*   `home/modules/applications/neovim/default.nix`: This file defines the Neovim configuration using the `mnw` flake, including plugins and LSPs.
