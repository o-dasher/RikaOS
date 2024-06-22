{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''
      require("thiago")
    '';
    extraPackages = with pkgs; [
      # LSP
      lua-language-server
      nixd
      phpactor
      yaml-language-server
      ccls
      pyright
      ruff-lsp
      texlab
      nodePackages.intelephense
      nodePackages."@tailwindcss/language-server"
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted

      # latex
      texliveFull
      nodejs

      # Some tools
      tree-sitter # Tree-sitting
      ripgrep # Telescope fzf
      gcc # Installing tree-sitteer grammars
    ];
  };
}
