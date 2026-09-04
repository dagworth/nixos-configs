{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;
      userChrome = ../dotfiles/firefox/chrome/userChrome.css;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}