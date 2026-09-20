{ pkgs, mnw }:
mnw.lib.wrap pkgs {
  initLua = # lua
    ''require("thiago")'';

  plugins = with pkgs.vimPlugins; {
    start = [
      lze

      # Plugins that already handle lazy-loading
      rustaceanvim
      vimtex
    ];

    opt = [
      conform-nvim
      nvim-lspconfig
      blink-cmp
      nvim-treesitter.withAllGrammars
      oil-nvim
      mini-pairs
      mini-icons
      mini-visits
      rose-pine
      nvim-lint
      render-markdown-nvim
      snacks-nvim
      cord-nvim
      friendly-snippets
      typst-preview-nvim
    ];

    dev.config.pure = ../../dotfiles/nvim;
  };

  extraBinPath =
    with pkgs;
    [
      lspmux

      # Bash
      shfmt
      shellcheck

      # Lua
      stylua

      # Yaml
      yamllint

      # C-sharp
      csharpier

      # Rust
      clippy
      rustfmt

      # C and CPP
      cppcheck

      # Nix
      statix
      nixfmt

      # Python
      ruff

      # PHP
      intelephense
      phpstan
      phpPackages.php-cs-fixer

      # Typescript
      typescript
      biome

      # latex
      texliveFull

      # Typst
      typst
      typstyle

      # Dependencies
      nodejs

      # Some tools
      tree-sitter # Tree-sitting
      ripgrep # Telescope fzf

      # pdf viewer
      zathura

      # Integrated cli tools
      lazygit
    ]
    ++ (import ./lsp.nix {
      inherit pkgs;
      inherit (pkgs) lib;
    }).packages;
}
