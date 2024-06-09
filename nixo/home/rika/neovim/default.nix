{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      # LSP
      lua-language-server
      nixd
      phpactor
      yaml-language-server
      clang-tools_16
      pyright
      ruff-lsp
      nodePackages."@tailwindcss/language-server"
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted

      # Some tools
      tree-sitter # Code highlightning
      ripgrep # Telescope fzf
      gcc # Installing tree-sitteer grammars
    ];
  };
}
