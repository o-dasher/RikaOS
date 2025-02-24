{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.neovim.enable = lib.mkEnableOption "neovim";
  config =
    let
      selectiveSymLink =
        from: to: paths: opts:
        lib.mkMerge (
          map (path: {
            "${to}/${path}" = {
              source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath /. + "${from}/${path}");
            } // opts;
          }) paths
        );

      symLinkNeovim = selectiveSymLink ../../../../../nvim ".config/nvim";
    in
    lib.mkIf config.neovim.enable {
      home.file = lib.mkMerge [
        (symLinkNeovim [
          "lua"
          "ftplugin"
        ] { recursive = true; })
        (symLinkNeovim [ "lazy-lock.json" ] { })
      ];

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
