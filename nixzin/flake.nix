{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
	inherit (import ./system/variables.nix) hostname system;
	inherit (import ./home/variables.nix) username;
    pkgs = import nixpkgs {inherit system;};
  in {
	homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [../home/home.nix];
    };

    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [./system/configuration.nix];
    };
  };
}
