hl.env("XCURSOR_SIZE", "15")
hl.env("HYPRCURSOR_SIZE", "15")

hl.env("XCURSOR_THEME", "Breeze")
hl.env("HYPRCURSOR_THEME", "Breeze")

-- without this, Electron apps (Discord, Spotify) launch through XWayland
-- and don't pick up the monitor's fractional scale, starting tiny
hl.env("NIXOS_OZONE_WL", "1")

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
