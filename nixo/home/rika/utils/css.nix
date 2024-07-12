let
  theme_string = merge: "@theme_${merge}";
  gen_css_fn = fn_name: args: "${fn_name}(${args})";
  apply_numeric_css_fn =
    fn_name: property: value:
    gen_css_fn fn_name "${property}, ${toString value}";
in
{
  font_definition = "font-family: JetBrainsMono;";
  apply_numeric_css_fn = apply_numeric_css_fn;
  alpha_fn = apply_numeric_css_fn "alpha";
  shade_fn = apply_numeric_css_fn "shade";
  gen_css_fn = gen_css_fn;
  theme = {
    bg_color = theme_string "bg_color";
    fg_color = theme_string "fg_color";
    base_color = theme_string "base_color";
    text_color = theme_string "text_color";
    selected_bg_color = theme_string "selected_bg_color";
    selected_fg_color = theme_string "selected_fg_color";
  };
}
