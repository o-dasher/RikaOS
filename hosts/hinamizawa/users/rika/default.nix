{
  pkgs,
  inputs,
  ...
}:
{
  programs = {
    home-manager.enable = true;
    imv.enable = true;
  };

  home = {
    sessionVariables.OSU_SDL3 = 1;
    packages =
      with pkgs;
      [
        # I love my keyboard.
        vial

        # tools
        bitwarden-desktop
        pwvucontrol

        # gaming
        shadps4-qtlauncher
        liborbispkg-pkgtool
      ]
      ++ [ inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin ];
  };

  profiles = {
    utilities.enable = true;
    gaming.enable = true;
    multimedia.enable = true;
    social.enable = true;
    browser.enable = true;
    study.enable = true;
    development = {
      enable = true;
      jetbrains.enable = true;
      zed.enable = true;
    };
  };

  features = {
    editors.jetbrains = {
      android-studio.enable = true;
      rider.enable = true;
      clion.enable = true;
    };
    utilities = {
      nemo.enable = true;
      trash.enable = true;
    };
    desktop = {
      umbriel.enable = true;
      theme.lucky-star.enable = true;
    };
    core.xdg = {
      enable = true;
      portal.enable = true;
    };
    gaming.minecraft.enable = true;
  };
}
