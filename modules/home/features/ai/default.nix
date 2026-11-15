{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ai;
  browserMcp = lib.getExe pkgs.playwright-mcp;
in
{
  options.features.ai.enable = lib.mkEnableOption "Personal AI agents, ACP, and MCP integration.";

  config = lib.mkIf cfg.enable {
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
        lspServers = {
          bash-language-server = {
            command = "bash-language-server";
            args = [ "start" ];
            fileExtensions = {
              ".sh" = "shellscript";
              ".bash" = "shellscript";
            };
          };
          clangd = {
            command = "clangd";
            args = [ ];
            fileExtensions = {
              ".c" = "c";
              ".cpp" = "cpp";
              ".h" = "c";
              ".hpp" = "cpp";
            };
          };
          lua-language-server = {
            command = "lua-language-server";
            args = [ ];
            fileExtensions = {
              ".lua" = "lua";
            };
          };
          nixd = {
            command = "nixd";
            args = [ ];
            fileExtensions = {
              ".nix" = "nix";
            };
          };
          phpactor = {
            command = "phpactor";
            args = [ "language-server" ];
            fileExtensions = {
              ".php" = "php";
            };
          };
          pyright-langserver = {
            command = "pyright-langserver";
            args = [ "--stdio" ];
            fileExtensions = {
              ".py" = "python";
            };
          };
          rust-analyzer = {
            command = "rust-analyzer";
            args = [ ];
            fileExtensions = {
              ".rs" = "rust";
            };
          };
          svelteserver = {
            command = "svelteserver";
            args = [ "--stdio" ];
            fileExtensions = {
              ".svelte" = "svelte";
            };
          };
          tailwindcss-language-server = {
            command = "tailwindcss-language-server";
            args = [ "--stdio" ];
            fileExtensions = {
              ".css" = "css";
            };
          };
          typescript-language-server = {
            command = "typescript-language-server";
            args = [ "--stdio" ];
            fileExtensions = {
              ".ts" = "typescript";
              ".tsx" = "typescriptreact";
              ".js" = "javascript";
              ".jsx" = "javascriptreact";
            };
          };
          vscode-css-language-server = {
            command = "vscode-css-languageserver";
            args = [ "--stdio" ];
            fileExtensions = {
              ".css" = "css";
            };
          };
          vscode-html-language-server = {
            command = "vscode-html-languageserver";
            args = [ "--stdio" ];
            fileExtensions = {
              ".html" = "html";
            };
          };
          vscode-json-language-server = {
            command = "vscode-json-languageserver";
            args = [ "--stdio" ];
            fileExtensions = {
              ".json" = "json";
            };
          };
          texlab = {
            command = "texlab";
            args = [ ];
            fileExtensions = {
              ".tex" = "latex";
            };
          };
          tinymist = {
            command = "tinymist";
            args = [ "lsp" ];
            fileExtensions = {
              ".typ" = "typst";
            };
          };
          yaml-language-server = {
            command = "yaml-language-server";
            args = [ "--stdio" ];
            fileExtensions = {
              ".yaml" = "yaml";
              ".yml" = "yaml";
            };
          };
        };
      };

      mcp = {
        enable = true;
        servers.cdp = {
          command = browserMcp;
          args = [ "--cdp-endpoint=http://127.0.0.1:9222" ];
        };
      };

      # ACP (Agent Client Protocol) agent servers & MCP context servers for Zed
      zed-editor = {
        enableMcpIntegration = true;
        userSettings.agent_servers.copilot = {
          args = [ "--acp" ];
          command = lib.getExe pkgs.github-copilot-cli;
          type = "custom";
        };
      };
    };
  };
}
