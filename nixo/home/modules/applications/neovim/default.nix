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
        devExcludedPlugins = [
          (config.lib.file.mkOutOfStoreSymlink ../../../../../dotfiles/nvim)
        ];
        plugins = with pkgs.vimPlugins; [
          lze
          conform-nvim
          fidget-nvim
          harpoon2
          indent-blankline-nvim
          nvim-lspconfig
          nvim-web-devicons
          lazygit-nvim
          nvim-lint
          render-markdown-nvim
          oil-nvim
          snacks-nvim
          friendly-snippets
          luasnip
          nvim-treesitter.withAllGrammars
          vimtex
          telescope-nvim
          telescope-live-grep-args-nvim
          blink-cmp
          rose-pine
          mini-pairs
          rustaceanvim
        ];
        extraBinPath = with pkgs; [
          # LSP
          lua-language-server # Lua
          nixd # Nix
          yaml-language-server # Yaml
          ccls # C
          rust-analyzer # Rust

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
          luarocks # I am not sure

          # global formatters
          prettierd
          nixfmt-rfc-style
          stylua
        ];
      };
    };
  };
}
