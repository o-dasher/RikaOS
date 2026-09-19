{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ai;

  openRouterApiUrl = "https://openrouter.ai/api/v1";

  chromeDevToolsMcp = pkgs.writeShellScript "chrome-devtools-mcp" ''
    export PATH="${lib.makeBinPath [ pkgs.nodejs ]}:$PATH"
    exec ${lib.getExe' pkgs.nodejs "npx"} --yes chrome-devtools-mcp@latest "$@"
  '';

  museModels = [
    {
      id = "meta/muse-spark-1.3-contributor";
      name = "Meta: Muse Spark 1.3 Contributor";
      maxTokens = 1048576;
    }
    {
      id = "meta/muse-spark-1.3";
      name = "Meta: Muse Spark 1.3";
      maxTokens = 1048576;
    }
  ];

in
{
  options.features.ai.enable = lib.mkEnableOption "Personal AI agents, ACP, and MCP integration.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ antigravity-acp ];

    programs = {
      antigravity-cli = {
        enable = true;
        enableMcpIntegration = true;
      };

      github-copilot-cli = {
        enable = true;
        enableMcpIntegration = true;
      };

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

      # ACP (Agent Client Protocol) agent servers & MCP context servers for Zed
      zed-editor = {
        enableMcpIntegration = true;
        userSettings = {
          agent_servers = {
            antigravity = {
              args = [ ];
              command = lib.getExe pkgs.antigravity-acp;
              type = "custom";
            };
            copilot = {
              args = [ "--acp" ];
              command = lib.getExe pkgs.github-copilot-cli;
              type = "custom";
            };
          };
          language_models.open_router = {
            api_url = openRouterApiUrl;
            available_models = map (m: {
              name = m.id;
              display_name = m.name;
              max_tokens = m.maxTokens;
              supports_tools = true;
              supports_images = true;
            }) museModels;
          };
        };
      };
    };
  };
}
