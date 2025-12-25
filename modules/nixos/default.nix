{ ... }:
{
  imports = [
    ./secure_boot.nix
    ./nix_setup.nix
    ./user_preferences.nix
    ./features
  ];

  stylix.homeManagerIntegration.autoImport = false;
  stylix.homeManagerIntegration.followSystem = false;
}
