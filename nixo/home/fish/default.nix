{ ... }:
{
  programs = {
    starship = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
    fish = {
      enable = true;
      catppuccin.enable = true;
      interactiveShellInit = ''
        		direnv hook fish | source
                starship init fish | source

                if status is-interactive
                	# Commands to run in interactive sessions can go here
                end

                function fish_greeting
                	echo Welcome(set_color magenta) home(set_color normal) $USER how are you doing today\?
                	echo (set_color magenta; date)
                end

                alias hm "home-manager switch --flake ~/.config/nixo"
      '';
    };
  };
}
