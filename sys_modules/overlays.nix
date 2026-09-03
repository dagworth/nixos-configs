{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (builtins.getFlake "github:SpotX-Official/SpotX-Nix/d1272d856bc132898aa6fad7f6d2ab8b9cb9ac66").overlays.default
  ];
}
