{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.neovim.enable = lib.mkOption { type = lib.types.bool; };
  config = lib.mkIf (config.neovim.enable) {
    # Will likely remove, it is so utter slow, and does not have proper resharper
    # support, maybe I need to test this again once I have an ssd.
    home.packages = with pkgs; [ omnisharp-roslyn ];
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
        luarocks

        # global formatters
        prettierd
        nixfmt-rfc-style
        stylua
      ];
    };
  };
}
