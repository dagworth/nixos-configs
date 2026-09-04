{ config, pkgs, ... }:

{
  imports = [
    ./home_modules/git.nix
    ./home_modules/vscode.nix
    ./home_modules/dotfiles.nix
    ./home_modules/discord.nix
    ./home_modules/spotify.nix
    ./home_modules/burpsuite.nix
    ./home_modules/qbittorrent.nix
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