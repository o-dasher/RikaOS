{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.editors;
  cfg = modCfg.zed;
in
{
  options.features.editors.zed.enable = lib.mkEnableOption "Zed editor.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.file = config.rika.utils.xdgConfigSelectiveSymLink "zed" [
      "keymap.json"
    ] { };

    programs.zed-editor = {
      enable = true;
      userSettings = {
        agent.auto_compact.threshold = "75%";
        base_keymap = "VSCode";
        collaboration_panel.dock = "right";
        format_on_save = "on";
        git_panel.dock = "right";
        gutter.folds = false;
        hard_tabs = false;
        outline_panel.dock = "right";
        project_panel.dock = "right";
        relative_line_numbers = "enabled";
        scrollbar.show = "never";
        show_wrap_guides = true;
        tab_bar.show = false;
        tab_size = 4;
        terminal.button = false;
        vertical_scroll_margin = 4;
        vim_mode = true;
        which_key.enabled = false;
        wrap_guides = [ 80 ];
        centered_layout = {
          left_padding = 0.15;
          right_padding = 0.15;
        };
        languages = {
          LaTeX.tab_size = 2;
          Typst.tab_size = 2;
        };
        toolbar = {
          breadcrumbs = false;
          quick_actions = false;
        };
        vim = {
          toggle_relative_line_numbers = true;
          use_system_clipboard = "never";
        };
      };
    };
  };
}
