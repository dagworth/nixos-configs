{ config, pkgs, ... }:

{
	programs.firefox = {
		enable = true;

		profiles.default = {
			isDefault = true;
			userChrome = ../dotfiles/firefox/chrome/userChrome.css;
			settings = {
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
				"font.default.x-western" = "sans-serif";
				"font.name.sans-serif.x-western" = "Atkinson Hyperlegible";
				"font.size.variable.x-western" = 15;
			};
		};
	};
}
