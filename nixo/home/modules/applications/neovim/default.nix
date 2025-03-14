{
  pkgs,
  config,
  lib,
  utils,
  ...
}:
let
in
{
  options.neovim.enable = lib.mkEnableOption "neovim";
  config = lib.mkIf config.neovim.enable {
    home.file =
      let
        symLinkNeovim = utils.xdgConfigSelectiveSymLink "nvim";
      in
      lib.mkMerge [
        (symLinkNeovim [
          "lua"
          "ftplugin"
        ] { recursive = true; })
      ];

    programs = {
      lazygit.enable = true;
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        extraLuaConfig = ''
          require("thiago")
        '';
        extraPackages = with pkgs; [
          # LSP
          # Lua
          lua-language-server

          nixd # Nix
          yaml-language-server # Yaml
          ccls # C

          # Python
          pyright
          ruff-lsp

          # Web development
          nodePackages."@tailwindcss/language-server"
          nodePackages.vscode-langservers-extracted

          # Typescript
          svelte-language-server
          typescript
          nodePackages.typescript-language-server

          # PHP
          nodePackages.intelephense
          phpactor

          # latex
          texliveFull
          texlab
          nodejs

          # Some tools
          tree-sitter # Tree-sitting
          ripgrep # Telescope fzf
          gcc # Installing tree-sitteer grammars
          luarocks

          # global formatters
          prettierd
          nixfmt-rfc-style
          stylua
        ];
      };
    };
  };
}
