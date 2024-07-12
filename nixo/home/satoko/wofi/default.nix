{ utils, ... }:
let
  inherit (utils) css;
  inherit (css) theme font_definition;
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
          	border: 1 solid; 
          }

          #inner-box, #outer-box, #input, window {
          	margin: ${decent_spacing};
          	border-radius: ${radius_definition};
          }
            
          #text {
          	margin: ${decent_spacing};
          	color: ${theme.text_color};
          }

          #entry:first-child {
          	border-top-left-radius: ${radius_definition};
          	border-top-right-radius: ${radius_definition};
          }

          #entry:last-child {
          	border-bottom-left-radius: ${radius_definition};
          	border-bottom-right-radius: ${radius_definition};
          }
        '';
      };
  };
}
