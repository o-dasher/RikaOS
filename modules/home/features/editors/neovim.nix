{
  pkgs,
  config,
  lib,
  ...
}:
let
  modCfg = config.features.editors;
  cfg = modCfg.neovim;
in
with lib;
{
  config = mkMerge [
    (mkIf (modCfg.enable && cfg.enable && cfg.neovide.enable) {
      programs.neovide.enable = true;
    })
    (mkIf (modCfg.enable && cfg.enable) {
      home.file = (config.rika.utils.xdgConfigSelectiveSymLink "nvim/lua/thiago") [
        "set.vim"
      ] { };

      programs = {
        lazygit.enable = true;
        mnw = {
          enable = true;
          initLua = # lua
            ''require("thiago")'';
          plugins = with pkgs.vimPlugins; {
            start = [
              lze

              # Plugins that already handle lazy-loading
              rustaceanvim
            ];

            opt = [
              conform-nvim
              nvim-lspconfig
              blink-cmp
              nvim-treesitter.withAllGrammars
              telescope-live-grep-args-nvim
              oil-nvim
              mini-pairs
              rose-pine
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
            yaml-language-server # Yaml
            llvmPackages.clang-tools # C and CPP
            omnisharp-roslyn # C-sharp
            rust-analyzer # Rust
            # Nix
            nixd
            statix
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
            nixfmt
            stylua
          ];
        };
      };
    })
  ];
}
