{ ... }:
{
  imports = [
    ../rika
    ./theme
    ./nixgl
  ];

  targets.genericLinux.enable = true;
}
