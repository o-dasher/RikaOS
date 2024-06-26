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
              css =
                let
                  theme_string = merge: "@theme_${merge}";
                  gen_css_fn = fn_name: args: "${fn_name}(${args})";
                  apply_numeric_css_fn =
                    fn_name: property: value:
                    gen_css_fn fn_name "${property}, ${toString value}";
                in
                {
                  font_definition = "font-family: JetBrainsMono;";
                  apply_numeric_css_fn = apply_numeric_css_fn;
                  alpha_fn = apply_numeric_css_fn "alpha";
                  shade_fn = apply_numeric_css_fn "shade";
                  gen_css_fn = gen_css_fn;
                  theme = {
                    bg_color = theme_string "bg_color";
                    fg_color = theme_string "fg_color";
                    base_color = theme_string "base_color";
                    text_color = theme_string "text_color";
                    selected_bg_color = theme_string "selected_bg_color";
                    selected_fg_color = theme_string "selected_fg_color";
                  };
                };
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
      homeConfigurations."${cfg.username}@gotec-MS-7D18" = define_hm [ ./home/hanyuu];
      homeConfigurations."${cfg.username}@gotec" = define_hm [ ./home/hanyuu];

      nixosConfigurations.${cfg.hostname} = nixpkgs.lib.nixosSystem {
        modules = [ ./system/configuration.nix ];
      };
    };
}
