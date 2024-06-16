{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      cfg = import ./config/myconfig.nix;
      define_hm =
        base:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            stylix.homeManagerModules.stylix
            ./config/setconfig.nix
          ] ++ base;
          extraSpecialArgs = {
            inherit inputs;
            utils = {
              prefixset =
                prefix: kvpairs:
                builtins.mapAttrs (
                  name: value: if builtins.typeOf prefix == "lambda" then prefix value else prefix + " " + value
                ) kvpairs;
            };
          };
        };
    in
    {
      homeConfigurations."${cfg.username}@nixo" = define_hm [ ./home/satoko ];
      homeConfigurations."${cfg.username}@fedora" = define_hm [ ./home/hanyuu ];

      nixosConfigurations.${cfg.hostname} = nixpkgs.lib.nixosSystem {
        modules = [ ./system/configuration.nix ];
      };
    };
}
