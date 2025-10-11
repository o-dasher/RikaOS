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
            lzextras
          ];

          opt = [
            conform-nvim
            nvim-lspconfig
            blink-cmp
            plenary-nvim
            nvim-treesitter.withAllGrammars
            telescope-live-grep-args-nvim
            telescope-nvim
            oil-nvim
            mini-pairs
            rose-pine
            lazygit-nvim
            harpoon2
            nvim-web-devicons
            fidget-nvim
            nvim-lint
            render-markdown-nvim
            snacks-nvim
            luasnip
            friendly-snippets
            vimtex
          ];

          dev.config.pure = ../../../../dotfiles/nvim;
        };
        extraBinPath = with pkgs; [
          # LSP
          lua-language-server
          nixd # Nix
          yaml-language-server # Yaml
          ccls # C
          omnisharp-roslyn # C-sharp
          rust-analyzer # Rust
          yaml-language-server # Yaml
          # Python
          pyright
          ruff
          # PHP
          nodePackages.intelephense
          phpactor
          # Web development
          nodePackages."@tailwindcss/language-server"
          nodePackages.vscode-langservers-extracted
          # Typescript
          svelte-language-server
          typescript
          biome
          nodePackages.typescript-language-server
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
