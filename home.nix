{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix
    ./home_modules/hyprland.nix
    ./modules/vscode.nix
    #./home_modules/dotfiles.nix
  ];
  # Always match this version to your NixOS/Home-Manager release
  home.stateVersion = "26.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
  home.username = "larry";
  home.homeDirectory = "/home/larry";

  # User-specific packages that don't need root installation
  home.packages = with pkgs; [
    htop
    kitty
    brightnessctl
  ];

  programs.quickshell.enable = true;
  programs.firefox.enable = true;
}