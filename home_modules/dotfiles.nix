# home_modules/dotfiles.nix
{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    "hypr".source = mkOutOfStoreSymlink ../dotfiles/hypr;
    "quickshell".source = mkOutOfStoreSymlink ../dotfiles/quickshell;
    "kitty".source = mkOutOfStoreSymlink ../dotfiles/kitty;
    "gtk-3.0".source = mkOutOfStoreSymlink ../dotfiles/gtk-3.0;
    "gtk-4.0".source = mkOutOfStoreSymlink ../dotfiles/gtk-4.0;
  };

  home.file = {
    ".bashrc".source = mkOutOfStoreSymlink ../dotfiles/.bashrc;
  };
}
