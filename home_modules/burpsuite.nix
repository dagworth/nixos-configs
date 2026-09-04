{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.burpsuite
  ];
}