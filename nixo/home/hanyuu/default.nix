{ ... }:
{
  imports = [
    ../rika
    ./theme
    ./nixgl
    ./gnome
  ];

  targets.genericLinux.enable = true;
}
