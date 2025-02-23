{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.neovim.enable = lib.mkEnableOption "neovim";
  config = lib.mkIf config.neovim.enable {
    xdg.configFile = {
      "nvim/lua" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ../../../../nvim/lua;
      };

      "nvim/ftplugin" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ../../../../nvim/ftplugin;
      };
    };

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
        nodePackages.vscode-langservers-extracted
        # typescript support
        svelte-language-server
        typescript
        nodePackages.typescript-language-server

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
