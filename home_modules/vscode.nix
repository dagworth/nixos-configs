{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      dracula-theme.theme-dracula
      vscode-icons-team.vscode-icons
    ];

    profiles.default.userSettings = {
      "editor.fontSize" = 16;
      "editor.tabSize" = 4;
      "files.trimTrailingWhitespace" = true;
      "workbench.iconTheme" = "vscode-icons";
      "workbench.colorCustomizations" = {
        "sideBar.foreground" = "#b4a3c1";
      };
      "workbench.colorTheme" = "Dracula Theme";
      "workbench.tree.indent" = 16;
      "workbench.tree.renderIndentGuides" = "always";
      "workbench.activityBar.location" = "bottom";
    };
  };
}