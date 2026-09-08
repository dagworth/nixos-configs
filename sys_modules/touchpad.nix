{ pkgs, ... }:

{
 systemd.services.touchpad-reload = {
   description = "reload i2c-hid so that touchpad wont break";
   wantedBy = [ "multi-user.target" ];
   after = [ "multi-user.target" ];
   path = [ pkgs.kmod ];
   script = ''
     sleep 5
     modprobe -r i2c_hid_acpi || true
     modprobe i2c_hid_acpi || true
   '';
   serviceConfig.Type = "oneshot";
 };

 powerManagement.resumeCommands = ''
   ${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi || true
   ${pkgs.kmod}/bin/modprobe i2c_hid_acpi || true
 '';
}


