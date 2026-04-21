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
    ];

    dev.config.pure = ../../dotfiles/nvim;
  };

  extraBinPath = with pkgs; [
    # Bash
    bash-language-server
    shfmt
    shellcheck

    # Lua
    lua-language-server
    stylua

    # Yaml
    yaml-language-server
    yamllint

    # C-sharp
    omnisharp-roslyn
    csharpier

    # Rust
    rust-analyzer
    clippy
    rustfmt

    # C and CPP
    llvmPackages.clang-tools

    # Nix
    nixd
    statix
    nixfmt

    # Python
    pyright
    ruff

    # PHP
    intelephense
    phpactor
    phpstan
    phpPackages.php-cs-fixer

    # Web development
    tailwindcss-language-server
    vscode-langservers-extracted

    # Typescript
    svelte-language-server
    typescript
    biome
    typescript-language-server

    # latex
    texliveFull
    texlab

    # Dependencies
    nodejs

    # Some tools
    tree-sitter # Tree-sitting
    ripgrep # Telescope fzf

    # pdf viewer
    zathura

    # Integrated cli tools
    lazygit
  ];
}
