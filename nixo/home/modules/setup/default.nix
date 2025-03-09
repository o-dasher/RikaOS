{ utils, ... }:
{
  imports = [
    ./nix
    ./xdg
    ./home
  ];

  home.file = (
    utils.xdgConfigSelectiveSymLink "ideavim" [
      "ideavimrc"
    ] { }
  );
}
