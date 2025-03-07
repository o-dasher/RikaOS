let
  gen_css_fn = fn_name: args: "${fn_name}(${args})";
  apply_numeric_css_fn =
    fn_name: property: value:
    gen_css_fn fn_name "${property}, ${toString value}";
in
{
  font_definition = "font-family: 'JetBrainsMono Nerd Font';";
  apply_numeric_css_fn = apply_numeric_css_fn;
  alpha_fn = apply_numeric_css_fn "alpha";
  shade_fn = apply_numeric_css_fn "shade";
}
