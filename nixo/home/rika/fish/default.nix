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
		tls = "tmux ls";
		tks = "tmux kill-session";
        hm = "home-manager switch --flake ~/.config/nixo";
		lg = "lazygit";
        sail = "bash vendor/bin/sail";
      };
      interactiveShellInit = ''
        function fish_greeting
        	echo Welcome(set_color magenta) home(set_color normal) $USER how are you doing today\?
        	echo (set_color magenta; date)
        end
      '';
    };
  };
}
