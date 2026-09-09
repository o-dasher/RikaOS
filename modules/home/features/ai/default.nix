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
in
{
  options.features.ai = {
    enable = lib.mkEnableOption "Personal AI agents, ACP, and MCP integration.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      antigravity-acp
    ];

    programs = {
      mcp = {
        enable = true;
        servers.chrome_devtools = {
          command = "${chromeDevToolsMcp}";
          args = [
            "--browserUrl"
            "http://127.0.0.1:9222"
          ];
        };
      };

      github-copilot-cli = {
        enable = true;
        enableMcpIntegration = true;
      };

      antigravity-cli = {
        enable = true;
        enableMcpIntegration = true;
      };

      # ACP (Agent Client Protocol) agent servers & MCP context servers for Zed
      zed-editor = {
        enableMcpIntegration = true;
        userSettings.agent_servers = {
          copilot = {
            type = "custom";
            command = lib.getExe pkgs.github-copilot-cli;
            args = [ "--acp" ];
          };
          antigravity = {
            type = "custom";
            command = lib.getExe pkgs.antigravity-acp;
            args = [ ];
          };
        };
      };
    };
  };
}
