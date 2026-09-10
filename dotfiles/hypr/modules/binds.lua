hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind("SUPER + space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + C", hl.dsp.window.close())

hl.bind("SUPER + equal", hl.dsp.exec_cmd("brightnessctl set +10%"))
hl.bind("SUPER + minus", hl.dsp.exec_cmd("brightnessctl set 10%-"))

hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" -t jpeg - | tee ~/Pictures/\"$(date +%m-%d-%Y-%I:%M%P).jpg\" | wl-copy"))
hl.bind("Print", hl.dsp.exec_cmd("grim -t jpeg - | tee ~/Pictures/\"$(date +%m-%d-%Y-%I:%M%P).jpg\" | wl-copy"))

hl.bind("SUPER + grave", hl.dsp.exec_cmd("playerctl --player=spotify play-pause"))

for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && quickshell ipc call sound flash"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && quickshell ipc call sound flash"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })