{
  inputs,
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
    home.file = (utils.xdgConfigSelectiveSymLink "nvim/lua/thiago") [
      "set.vim"
    ] { };

    programs = {
      lazygit.enable = true;
      mnw = {
        enable = true;
        neovim = inputs.neovim-nightly.packages.${pkgs.system}.neovim;
        initLua = # lua
          ''require("thiago")'';
        plugins = with pkgs.vimPlugins; {
          start = [
            lze
            conform-nvim
            fidget-nvim
            harpoon2
            nvim-lspconfig
            nvim-web-devicons
            lazygit-nvim
            nvim-lint
            plenary-nvim
            render-markdown-nvim
            oil-nvim
            snacks-nvim
            friendly-snippets
            luasnip
            nvim-treesitter.withAllGrammars
            vimtex
            blink-cmp
            rose-pine
            mini-pairs
          ];

          opt = [
            telescope-live-grep-args-nvim
            telescope-nvim
          ];

          dev.config.pure = ../../../../dotfiles/nvim;
        };
        extraBinPath = with pkgs; [
          # LSP
          lua-language-server
          nixd # Nix
          yaml-language-server # Yaml
          ccls # C
          rust-analyzer # Rust

          # Yaml
          yaml-language-server

          # Python
          pyright
          ruff

          # Web development
          nodePackages."@tailwindcss/language-server"
          nodePackages.vscode-langservers-extracted

          # Typescript
          svelte-language-server
          typescript
          biome
          nodePackages.typescript-language-server

          nodePackages.intelephense
          phpactor

          # latex
          texliveFull
          texlab
          nodejs

          # Some tools
          tree-sitter # Tree-sitting
          ripgrep # Telescope fzf
          luarocks # I am not sure

          # global formatters
          nixfmt-rfc-style
          stylua
        ];
      };
    };
  };
}
