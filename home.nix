{ config, pkgs, ... }:

{
  imports = [
    ./home_modules/git.nix
    ./home_modules/vscode.nix
    ./home_modules/dotfiles.nix
    ./home_modules/discord.nix
    ./home_modules/firefox.nix
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
    rofi
    hyprpaper
    burpsuite
    qbittorrent
    yazi
    pkgs.spotify-spotx
    fastfetch
    vlc
    mpv
    micro
    pokeget-rs
    pulseaudio
  ];

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  programs.quickshell.enable = true;
}