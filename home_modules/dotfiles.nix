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
  };

  home.file = {
    ".bashrc".source = mkOutOfStoreSymlink ../dotfiles/.bashrc;
  };
}
