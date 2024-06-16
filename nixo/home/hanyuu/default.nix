{ ... }:
{
  imports = [
    ../rika
    ./theme
    ./nixgl
  ];

  targets.genericLinux.enable = true;
  programs = {
    gnome-shell.enable = true;
  };
}
