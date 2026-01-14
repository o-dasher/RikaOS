{
  description = "Hypr* ecosystem bleeding edge flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-parts.url = "github:hercules-ci/flake-parts";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aquamarine = {
      url = "github:hyprwm/aquamarine";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };

    hyprcursor = {
      url = "github:hyprwm/hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprlang.follows = "hyprlang";
    };

    hyprgraphics = {
      url = "github:hyprwm/hyprgraphics";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprutils.follows = "hyprutils";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprland-protocols.follows = "hyprland-protocols";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.pre-commit-hooks.follows = "git-hooks";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprcursor.follows = "hyprcursor";
      inputs.hyprgraphics.follows = "hyprgraphics";
      inputs.hyprland-guiutils.follows = "hyprland-guiutils";
      inputs.hyprland-protocols.follows = "hyprland-protocols";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
      inputs.hyprwire.follows = "hyprwire";
      inputs.xdph.follows = "xdph";
    };

    hyprland-guiutils = {
      url = "github:hyprwm/hyprland-guiutils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprgraphics.follows = "hyprgraphics";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprtoolkit.follows = "hyprtoolkit";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-protocols = {
      url = "github:hyprwm/hyprland-protocols";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hyprland-qt-support = {
      url = "github:hyprwm/hyprland-qt-support";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprlang.follows = "hyprlang";
    };

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprutils.follows = "hyprutils";
    };

    hyprlauncher = {
      url = "github:hyprwm/hyprlauncher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprgraphics.follows = "hyprgraphics";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprtoolkit.follows = "hyprtoolkit";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
      inputs.hyprwire.follows = "hyprwire";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprgraphics.follows = "hyprgraphics";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprgraphics.follows = "hyprgraphics";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprtoolkit.follows = "hyprtoolkit";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
      inputs.hyprwire.follows = "hyprwire";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };

    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprland-qt-support.follows = "hyprland-qt-support";
      inputs.hyprutils.follows = "hyprutils";
    };

    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprland-protocols.follows = "hyprland-protocols";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };

    hyprshutdown = {
      url = "github:hyprwm/hyprshutdown";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprgraphics.follows = "hyprgraphics";
      inputs.hyprtoolkit.follows = "hyprtoolkit";
      inputs.hyprutils.follows = "hyprutils";
    };

    hyprtoolkit = {
      url = "github:hyprwm/hyprtoolkit";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprgraphics.follows = "hyprgraphics";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };

    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hyprwayland-scanner = {
      url = "github:hyprwm/hyprwayland-scanner";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hyprwire = {
      url = "github:hyprwm/hyprwire";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprutils.follows = "hyprutils";
    };

    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hyprland-protocols.follows = "hyprland-protocols";
      inputs.hyprlang.follows = "hyprlang";
      inputs.hyprutils.follows = "hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprwayland-scanner";
    };
  };

  outputs =
    { flake-parts, systems, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      flake = {
        inherit inputs;
      };

      perSystem =
        { system, ... }:
        {
          packages = {
            default = inputs.hyprland.packages.${system}.hyprland;
            inherit (inputs.aquamarine.packages.${system}) aquamarine;
            inherit (inputs.hyprcursor.packages.${system}) hyprcursor;
            inherit (inputs.hyprgraphics.packages.${system}) hyprgraphics;
            inherit (inputs.hypridle.packages.${system}) hypridle;
            inherit (inputs.hyprland-guiutils.packages.${system}) hyprland-guiutils;
            inherit (inputs.hyprland.packages.${system}) hyprland;
            inherit (inputs.hyprland-protocols.packages.${system}) hyprland-protocols;
            inherit (inputs.hyprland-qt-support.packages.${system}) hyprland-qt-support;
            inherit (inputs.hyprlang.packages.${system}) hyprlang;
            inherit (inputs.hyprlauncher.packages.${system}) hyprlauncher;
            inherit (inputs.hyprlock.packages.${system}) hyprlock;
            inherit (inputs.hyprpaper.packages.${system}) hyprpaper;
            inherit (inputs.hyprpicker.packages.${system}) hyprpicker;
            inherit (inputs.hyprpolkitagent.packages.${system}) hyprpolkitagent;
            inherit (inputs.hyprshutdown.packages.${system}) hyprshutdown;
            inherit (inputs.hyprsunset.packages.${system}) hyprsunset;
            inherit (inputs.hyprtoolkit.packages.${system}) hyprtoolkit;
            inherit (inputs.hyprutils.packages.${system}) hyprutils;
            inherit (inputs.hyprwayland-scanner.packages.${system}) hyprwayland-scanner;
            inherit (inputs.hyprwire.packages.${system}) hyprwire;
            inherit (inputs.xdph.packages.${system}) xdg-desktop-portal-hyprland;
          }
          // inputs.hyprland-plugins.packages.${system};
        };
    };
}
