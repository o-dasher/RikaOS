{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ai;
in
{
  options.features.ai = {
    enable = lib.mkEnableOption "Personal AI agents, ACP, and MCP integration.";
  };

  config = lib.mkIf cfg.enable {
    programs = {
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

    home.packages = with pkgs; [
      antigravity-acp
    ];
  };
}
