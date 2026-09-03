{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name  = "larry";
      email = "larryhe360@gmail.com";
    };
  };
}