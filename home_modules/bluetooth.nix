{ config, pkgs, ... }:

{
	home.packages = [ pkgs.bluez-tools ];

	systemd.user.services.bt-agent = {
		Unit = {
			Description = "Bluetooth pairing agent (auto-trusts paired devices)";
			After = [ "graphical-session.target" ];
			PartOf = [ "graphical-session.target" ];
		};

		Service = {
			ExecStart = "${pkgs.bluez-tools}/bin/bt-agent -c NoInputNoOutput";
			Restart = "on-failure";
		};

		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};
}
