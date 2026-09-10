# home_modules/dotfiles.nix
{ config, pkgs, ... }:

let
	inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
	xdg.configFile = {
		"hypr".source = mkOutOfStoreSymlink ../dotfiles/hypr;
		"quickshell".source = mkOutOfStoreSymlink ../dotfiles/quickshell;
		"kitty".source = mkOutOfStoreSymlink ../dotfiles/kitty;
		"rofi".source = mkOutOfStoreSymlink ../dotfiles/rofi;
		"Code/User/settings.json".source = ../dotfiles/vscode/settings.json;
	};

	home.file = {
		".bashrc".source = mkOutOfStoreSymlink ../dotfiles/.bashrc;
	};
}
