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

  extraBinPath = with pkgs; [
    lspmux
    ripgrep
    tree-sitter
    lazygit
    zathura
  ];
}
