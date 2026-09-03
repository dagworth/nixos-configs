# home_modules/dotfiles.nix
{ config, pkgs, ... }:

{
  xdg.configFile = {
    "hypr".source = ../dotfiles/hypr;
    "quickshell".source = ../dotfiles/quickshell;
  };
}