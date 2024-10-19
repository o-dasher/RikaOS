# Welcome to RikaOS

These are all my configurations that I use to manage my NixOS setup and Home Manager.

# So what this does?

- Sets up all apps I use, such as neovim, wezterm, lazygit and everything else on all of my computers.

* Styles everything - outside of gtk - on my computer using stylix, for whatever reason gtk styling seems broken when trying to do it through home-manager on gnome, and yes I use gnome on some of my computers, mainly my research lab computers.

# Hosts

I actually only use NixOS on my home computer, so there is only a single proper NixOS host and it is called Nixo. The other hosts are for my lab, and they pretty much only rely on home-manager.

# FIle Strucutre

| Location       | Description                                                                                                 |
| -------------- | ----------------------------------------------------------------------------------------------------------- |
| nixo           | All my home-manager and nixos related configuration this is pretty much the main part of this repository    |
| nixo/home      | This directory contains all of my home-manager configuration                                                |
| nixo/home/rika | Global home manager configuration                                                                           |
| nixo/system    | My personal computer nixos system configuration                                                             |
| nvim           | My Neovim configuration, I still manage it without nix because I use lazy.nvim but I might migrate sometime |
| assets         | I find convenient to put my assets on this repository, such as my keyboard configuration and wallpapers     |
