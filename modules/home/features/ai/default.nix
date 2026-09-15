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

      opencode = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          model = "openrouter/meta/muse-spark-1.3-contributor";
          provider = {
            openrouter = {
              models = {
                "meta/muse-spark-1.3-contributor" = {
                  name = "Meta: Muse Spark 1.3 Contributor";
                };
                "meta/muse-spark-1.2-contributor" = {
                  name = "Meta: Muse Spark 1.2 Contributor";
                };
                "meta/muse-glimmer-30b" = {
                  name = "Meta: Muse Glimmer 30B";
                };
                "meta/muse-spark-1.3" = {
                  name = "Meta: Muse Spark 1.3";
                };
              };
            };
          };
        };
      };

      codex = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          model_provider = "openrouter";
          model = "meta/muse-spark-1.3-contributor";
          model_providers = {
            openrouter = {
              name = "OpenRouter";
              base_url = "https://openrouter.ai/api/v1";
              env_key = "OPENROUTER_API_KEY";
              wire_api = "responses";
            };
          };
        };
        profiles = {
          muse = {
            model_provider = "openrouter";
            model = "meta/muse-spark-1.3-contributor";
          };
          muse-spark-1-3-contributor = {
            model_provider = "openrouter";
            model = "meta/muse-spark-1.3-contributor";
          };
          muse-spark-1-2-contributor = {
            model_provider = "openrouter";
            model = "meta/muse-spark-1.2-contributor";
          };
          muse-glimmer = {
            model_provider = "openrouter";
            model = "meta/muse-glimmer-30b";
          };
          muse-spark = {
            model_provider = "openrouter";
            model = "meta/muse-spark-1.3";
          };
        };
      };

      # ACP (Agent Client Protocol) agent servers & MCP context servers for Zed
      zed-editor = {
        enableMcpIntegration = true;
        userSettings = {
          agent_servers = {
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
          language_models = {
            open_router = {
              api_url = "https://openrouter.ai/api/v1";
              available_models = [
                {
                  name = "meta/muse-spark-1.3-contributor";
                  display_name = "Meta: Muse Spark 1.3 Contributor";
                  max_tokens = 1048576;
                  supports_tools = true;
                  supports_images = true;
                }
                {
                  name = "meta/muse-spark-1.2-contributor";
                  display_name = "Meta: Muse Spark 1.2 Contributor";
                  max_tokens = 1048576;
                  supports_tools = true;
                  supports_images = true;
                }
                {
                  name = "meta/muse-glimmer-30b";
                  display_name = "Meta: Muse Glimmer 30B";
                  max_tokens = 131072;
                  supports_tools = true;
                  supports_images = true;
                }
                {
                  name = "meta/muse-spark-1.3";
                  display_name = "Meta: Muse Spark 1.3";
                  max_tokens = 1048576;
                  supports_tools = true;
                  supports_images = true;
                }
              ];
            };
          };
        };
      };
    };
  };
}
