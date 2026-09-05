{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      pokeget random
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}