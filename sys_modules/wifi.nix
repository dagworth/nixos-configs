{ pkgs, ... }:

let
	wifi = import ./secrets.nix { inherit pkgs; };
in
{
	networking.networkmanager.ensureProfiles.profiles.${wifi.ssid} = {
		connection = {
			id = wifi.ssid;
			type = "wifi";
			autoconnect = true;
		};
		wifi = {
			mode = "infrastructure";
			ssid = wifi.ssid;
		};
		wifi-security = {
			key-mgmt = "wpa-eap";
		};
		"802-1x" = {
			eap = "ttls;";
			phase2-auth = "pap";
			identity = wifi.identity;
			password = wifi.password;
			ca-cert = wifi.cert;
			domain-suffix-match = wifi.domain;
		};
		ipv4.method = "auto";
		ipv6.method = "auto";
	};
}
