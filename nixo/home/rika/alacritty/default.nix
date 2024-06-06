{
  programs.alacritty = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      window = {
        opacity = 0.9;
      };
	  shell = {
		  program = "fish";
	  };
      font = {
        builtin_box_drawing = true;
        size = 12;
        normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
      };
    };
  };
}
