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
      shellAliases = {
        hm = "home-manager switch --flake ~/.config/nixo";
        sail = "bash vendor/bin/sail";
      };
      interactiveShellInit = ''
        direnv hook fish | source
        starship init fish | source

        function fish_greeting
        	echo Welcome(set_color magenta) home(set_color normal) $USER how are you doing today\?
        	echo (set_color magenta; date)
        end
      '';
    };
  };
}
