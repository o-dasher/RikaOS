{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ai;

  chromeDevToolsMcp = pkgs.writeShellScript "chrome-devtools-mcp" ''
    export PATH="${lib.makeBinPath [ pkgs.nodejs ]}:$PATH"
    exec ${lib.getExe' pkgs.nodejs "npx"} --yes chrome-devtools-mcp@latest "$@"
  '';

  # Multiplexed LSP servers from flakes/neovim/lsp.nix
  lsp = import ../../../../flakes/neovim/lsp.nix { inherit pkgs lib; };

  lspmuxBin = lib.getExe pkgs.lspmux;
  lspmuxClient = srv: [
    "client"
    "--server-path"
    srv
  ];
in
{
  options.features.ai.enable = lib.mkEnableOption "Personal AI agents, ACP, and MCP integration.";

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        lspmux
        mcp-language-server
      ]
      ++ lsp.packages;

    systemd.user.services.lspmux = {
      Install.WantedBy = [ "default.target" ];
      Unit = {
        Description = "LSP multiplexer daemon";
        After = [ "network.target" ];
      };
      Service = {
        Restart = "on-failure";
        RestartSec = 3;
        ExecStart = "${lspmuxBin} server";
        Environment = [ "PATH=${lib.makeBinPath lsp.packages}:/run/current-system/sw/bin" ];
      };
    };

    programs = {
      antigravity-cli = {
        enable = true;
        enableMcpIntegration = true;
      };

      github-copilot-cli = {
        enable = true;
        enableMcpIntegration = true;
        lspServers = lib.mapAttrs (srv: exts: {
          command = lspmuxBin;
          args = lspmuxClient srv;
          fileExtensions = lib.genAttrs exts (_: srv);
        }) lsp.servers;
      };

      mcp = {
        enable = true;
        servers = {
          chrome_devtools = {
            command = "${chromeDevToolsMcp}";
            args = [
              "--browserUrl"
              "http://127.0.0.1:9222"
            ];
          };
        }
        // lib.mapAttrs' (
          srv: _:
          lib.nameValuePair "lsp_${srv}" {
            command = lib.getExe pkgs.mcp-language-server;
            args = [
              "-workspace"
              "."
              "-lsp"
              lspmuxBin
              "--"
            ]
            ++ (lspmuxClient srv);
          }
        ) lsp.servers;
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
