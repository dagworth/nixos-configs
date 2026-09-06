# home_modules/dotfiles.nix
{ config, pkgs, ... }:

{
  xdg.configFile = {
    "hypr".source = ../dotfiles/hypr;
    "quickshell".source = ../dotfiles/quickshell;
    "kitty".source = ../dotfiles/kitty;
  };

  home.file = {
    ".bashrc".source = ../dotfiles/.bashrc;
  };
}
