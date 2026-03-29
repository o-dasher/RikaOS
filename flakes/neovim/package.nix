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
      cord-nvim
    ];

    dev.config.pure = ../../dotfiles/nvim;
  };

  extraBinPath = with pkgs; [
    # LSP
    lua-language-server
    yaml-language-server # Yaml
    omnisharp-roslyn # C-sharp
    rust-analyzer # Rust
    llvmPackages.clang-tools # C and CPP
    # Nix
    nixd
    statix
    # Python
    pyright
    ruff
    # PHP
    intelephense
    phpactor
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
    nodejs

    # Some tools
    tree-sitter # Tree-sitting
    ripgrep # Telescope fzf

    # global formatters
    nixfmt
    stylua
    phpPackages.php-cs-fixer

    # pdf viewer
    zathura

    # Integrated cli tools
    lazygit
  ];
}
