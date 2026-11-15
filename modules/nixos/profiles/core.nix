{
  pkgs,
  ...
}:
{
  users.defaultUserShell = pkgs.fish;

  time.timeZone = "America/Porto_Velho";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "br-abnt2";

  programs = {
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  features.boot.limine.enable = true;
}
