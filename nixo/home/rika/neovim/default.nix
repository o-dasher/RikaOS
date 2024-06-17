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
      nodePackages.intelephense
      nodePackages."@tailwindcss/language-server"
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted

      # Some tools
      ripgrep # Telescope fzf
      gcc # Installing tree-sitteer grammars
    ];
  };
}
