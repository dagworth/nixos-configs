{ config, pkgs, ... }:

let
  background = ../dotfiles/greeter.jpg;

  astronautTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      DimBackground = "0.35";
      DimBackgroundColor = "#0c2930";
      CropBackground = "true";

      Font = "JetBrainsMono Nerd Font";
      HourFormat = "h:mm AP";
      DateFormat = "dddd, MMMM d";

      FormPosition = "center";
      HaveFormBackground = "true";
      PartialBlur = "false";
      FullBlur = "false";

      HeaderTextColor = "#cdd6f4";
      DateTextColor = "#cdd6f4";
      TimeTextColor = "#cdd6f4";

      FormBackgroundColor = "#260c2930";
      BackgroundColor = "#0c2930";

      LoginFieldBackgroundColor = "#051318";
      PasswordFieldBackgroundColor = "#051318";
      LoginFieldTextColor = "#cdd6f4";
      PasswordFieldTextColor = "#cdd6f4";
      UserIconColor = "#5daca2";
      PasswordIconColor = "#5daca2";

      PlaceholderTextColor = "#7c8a99";
      WarningColor = "#f38ba8";

      HideLoginButton = "true";
      LoginButtonTextColor = "#cdd6f4";
      LoginButtonBackgroundColor = "#2f5550";
      SystemButtonsIconsColor = "#cdd6f4";
      SessionButtonTextColor = "#cdd6f4";

      DropdownTextColor = "#cdd6f4";
      DropdownSelectedBackgroundColor = "#2f5550";
      DropdownBackgroundColor = "#0c2930";

      HighlightTextColor = "#cdd6f4";
      HighlightBackgroundColor = "#2f5550";
      HighlightBorderColor = "#5daca2";

      HoverUserIconColor = "#5daca2";
      HoverPasswordIconColor = "#5daca2";
      HoverSystemButtonsIconsColor = "#5daca2";
      HoverSessionButtonTextColor = "#5daca2";
    };
  };
in
{
  environment.etc."sddm/backgrounds/catpuccin.jpg".source = background;

  environment.systemPackages = [ astronautTheme ];

  services.displayManager.sddm.theme = "sddm-astronaut-theme";
  services.displayManager.sddm.extraPackages = [ astronautTheme ];
}