{ config, pkgs, ... }:

let
	inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
	programs.vscode = {
		enable = true;
		package = pkgs.vscode;

		profiles.default.extensions = with pkgs.vscode-extensions; [
			bbenoist.nix
			dracula-theme.theme-dracula
			vscode-icons-team.vscode-icons
		];
	};
}
