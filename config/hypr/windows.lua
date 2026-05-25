hl.window_rule({
    name = "firefox-pip",
    match = {
        class = "firefox",
        title = "Picture-in-Picture",
    },
    float = true,
    pin = true,
})

hl.window_rule({
    name = "calculator",
    match = { class = "org.gnome.Calculator" },
    float = true,
})

hl.window_rule({
    name = "galculator",
    match = { class = "galculator" },
    float = true,
})

hl.window_rule({
    name = "blueman",
    match = { class = "blueman-manager" },
    float = true,
})

hl.window_rule({
    name = "steam",
    match = { class = "steam" },
    float = true,
})

hl.window_rule({
    name = "steam-helper",
    match = { class = "steamwebhelper" },
    float = true,
})

hl.window_rule({
    name = "windscribe",
    match = { class = "Windscribe" },
    float = true,
})

hl.window_rule({
    name = "portal-gtk",
    match = { class = "xdg-desktop-portal-gtk" },
    float = true,
})

hl.window_rule({
    name = "gnome-settings",
    match = { class = "gnome-control-center" },
    float = true,
})

hl.window_rule({
    name = "pavucontrol",
    match = { class = "pavucontrol" },
    float = true,
})

hl.window_rule({
    name = "nm-editor",
    match = { class = "nm-connection-editor" },
    float = true,
})

hl.window_rule({
    name = "zoom",
    match = { class = "zoom" },
    float = true,
})

hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

return true
