{ ... }:
let
  inherit (import ../utils/css.nix) alpha_fn theme font_definition;
in
{
  config = {
    programs.wofi =
      let
        decent_spacing = "8";
        radius_definition = "10";
      in
      {
        enable = true;
        settings = {
          width = "25%";
        };
        style = ''
          * {
          	${font_definition}
          }
            
          window {
          	border: 1 solid ${theme.selected_bg_color};
          }

          #input {
          	color: white;
          }

          #inner-box {
              background-color: ${alpha_fn theme.selected_bg_color 0.25};
          }

          #outer-box {
          	background-color: ${theme.bg_color};
          }

          #inner-box, #outer-box, #input, window {
          	margin: ${decent_spacing};
          	border-radius: ${radius_definition};
          }
            
          #text {
          	margin: ${decent_spacing};
          	color: ${theme.text_color};
          }

          #entry {
          	border-radius: 0;
          }

          #entry:first-child {
          	border-top-left-radius: ${radius_definition};
          	border-top-right-radius: ${radius_definition};
          }

          #entry:last-child {
          	border-bottom-left-radius: ${radius_definition};
          	border-bottom-right-radius: ${radius_definition};
          }

          #entry:selected {
          	background-color: ${alpha_fn theme.selected_bg_color 0.5};
          }
            
          #text:selected {
          	text-decoration-color: ${theme.text_color};
          }
        '';
      };
  };
}
