{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ai;
  browserMcp = lib.getExe pkgs.playwright-mcp;

  lsp = import ../../../../flakes/neovim/lsp.nix;

  lspClientServers = lib.mapAttrs (srv: exts: {
    command = srv;
    fileExtensions = lib.genAttrs exts (_: srv);
  }) lsp.servers;

in
{
  options.features.ai.enable = lib.mkEnableOption "Personal AI agents, ACP, and MCP integration.";

  config = lib.mkIf cfg.enable {
    xdg.configFile."efm-langserver/config.yaml".source = ../../../../dotfiles/nvim/efm-config.json;
    home.packages = with pkgs; [ efm-langserver ];

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
          tools = [
            "browser_console_messages"
            "browser_evaluate"
            "browser_file_upload"
            "browser_fill_form"
            "browser_find"
            "browser_handle_dialog"
            "browser_navigate"
            "browser_navigate_back"
            "browser_network_request"
            "browser_network_requests"
            "browser_press_key"
            "browser_resize"
            "browser_select_option"
            "browser_snapshot"
            "browser_take_screenshot"
            "browser_type"
            "browser_wait_for"
            "browser_tabs"
          ];
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
              path = srv;
            };
          }) lsp.servers;
        };
      };
    };
  };
}
