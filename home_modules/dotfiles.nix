# home_modules/dotfiles.nix
{ config, pkgs, ... }:

{
  xdg.configFile = {
    "hypr".source = ../dotfiles/hypr;
    "quickshell".source = ../dotfiles/quickshell;
    "kitty".source = ../dotfiles/kitty;
  };

  programs.firefox.profiles.default = {
    isDefault = true;
    userChrome = ../dotfiles/firefox/chrome/userChrome.css;
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };
}
