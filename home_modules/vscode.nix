{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      ms-python.python
    ];

    profiles.default.userSettings = {
      "editor.fontSize" = 16;
      "editor.tabSize" = 4;
      "files.trimTrailingWhitespace" = true;
      "nix.enableLanguageServer" = true;
    };
  };
}