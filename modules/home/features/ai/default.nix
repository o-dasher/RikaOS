{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ai;

  pow = base: exp: if exp == 0 then 1 else base * (pow base (exp - 1));
  pow2 = pow 2;

  openRouterApiUrl = "https://openrouter.ai/api/v1";

  chromeDevToolsMcp = pkgs.writeShellScript "chrome-devtools-mcp" ''
    export PATH="${lib.makeBinPath [ pkgs.nodejs ]}:$PATH"
    exec ${lib.getExe' pkgs.nodejs "npx"} --yes chrome-devtools-mcp@latest "$@"
  '';

  museModels = [
    {
      id = "meta/muse-spark-1.3-contributor";
      name = "Meta: Muse Spark 1.3 Contributor";
      profile = "muse-spark-1-3-contributor";
      maxTokens = pow2 20;
    }
    {
      id = "meta/muse-spark-1.2-contributor";
      name = "Meta: Muse Spark 1.2 Contributor";
      profile = "muse-spark-1-2-contributor";
      maxTokens = pow2 20;
    }
    {
      id = "meta/muse-glimmer-30b";
      name = "Meta: Muse Glimmer 30B";
      profile = "muse-glimmer";
      maxTokens = pow2 17;
    }
    {
      id = "meta/muse-spark-1.3";
      name = "Meta: Muse Spark 1.3";
      profile = "muse-spark";
      maxTokens = pow2 20;
    }
  ];

  defaultMuseModel = builtins.head museModels;

  codexMuseProfile = model: {
    inherit model;
    model_provider = "openrouter";
  };
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

      opencode = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          model = "openrouter/${defaultMuseModel.id}";
          provider.openrouter.models = lib.listToAttrs (
            map (m: {
              name = m.id;
              value = { inherit (m) name; };
            }) museModels
          );
        };
      };

      codex = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          model = defaultMuseModel.id;
          model_provider = "openrouter";
          model_providers.openrouter = {
            base_url = openRouterApiUrl;
            env_key = "OPENROUTER_API_KEY";
            name = "OpenRouter";
            wire_api = "responses";
          };
        };
        profiles = {
          muse = codexMuseProfile defaultMuseModel.id;
        }
        // lib.listToAttrs (
          map (m: {
            name = m.profile;
            value = codexMuseProfile m.id;
          }) museModels
        );
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
