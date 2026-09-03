{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    # Install extensions automatically from Nixpkgs
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix          # Nix language support
      ms-python.python    # Python support (uncomment if needed)
      # eamodio.gitlens     # Git integration
    ];

    # Directly manage VS Code's settings.json
    profiles.default.userSettings = {
      "editor.fontSize" = 14;
      "editor.tabSize" = 2;
      "workbench.colorTheme" = "Default Dark Modern";
      "files.trimTrailingWhitespace" = true;
      "nix.enableLanguageServer" = true;
    };
  };
}