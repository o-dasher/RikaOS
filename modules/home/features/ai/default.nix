{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ai;
  browserMcp = lib.getExe pkgs.playwright-mcp;

  # Multiplexed LSP servers from flakes/neovim/lsp.nix
  lsp = import ../../../../flakes/neovim/lsp.nix;
  lspmuxBin = lib.getExe pkgs.lspmux;

  lspmuxClient = srv: [
    "client"
    "--server-path"
    srv
  ];

  lspClientServers = lib.mapAttrs (srv: exts: {
    command = lspmuxBin;
    args = lspmuxClient srv;
    fileExtensions = lib.genAttrs exts (_: srv);
  }) lsp.servers;

in
{
  options.features.ai.enable = lib.mkEnableOption "Personal AI agents, ACP, and MCP integration.";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.lspmux ];

    xdg.configFile = {
      "efm-langserver/config.yaml".source = ../../../../dotfiles/nvim/efm-config.json;
      "lspmux/config.toml".text = ''
        pass_environment = ["PATH"]
      '';
    };

    systemd.user.services.lspmux = {
      Install.WantedBy = [ "default.target" ];
      Unit = {
        Description = "LSP multiplexer daemon";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${lspmuxBin} server";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };

    programs = {
      codex = {
        enable = true;
        enableMcpIntegration = true;
      };
      antigravity-cli = {
        enable = true;
        enableMcpIntegration = true;
      };

      github-copilot-cli = {
        enable = true;
        enableMcpIntegration = true;
        lspServers = lspClientServers;
      };

      mcp = {
        enable = true;
        servers.browser = {
          command = browserMcp;
          args = [ "--cdp-endpoint=http://127.0.0.1:9222" ];
        };
      };

      # ACP (Agent Client Protocol) agent servers & MCP context servers for Zed
      zed-editor = {
        enableMcpIntegration = true;
        userSettings = {
          agent_servers.copilot = {
            args = [ "--acp" ];
            command = lib.getExe pkgs.github-copilot-cli;
            type = "custom";
          };
          lsp = lib.mapAttrs (srv: _: {
            binary = {
              path = lspmuxBin;
              arguments = lspmuxClient srv;
            };
          }) lsp.servers;
        };
      };
    };
  };
}
