hl.monitor({
    output = "HDMI-A-2",
    mode = "3840x2160@60.000",
    position = "1920x0",
    scale = 1.5,
})

hl.monitor({
    output = "DP-3",
    mode = "1920x1200@59.950",
    position = "0x240",
    scale = 1,
})

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-3",
    default = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "HDMI-A-2",
    default = true,
})

hl.window_rule({
    name = "com.example.my_proj-home",
    match = { class = "^(com.example.my_proj)$" },
    float = true,
    size = { 1600, 1200 },
    workspace = "4 silent",
    no_initial_focus = true,
})

hl.window_rule({
    name = "thet-home",
    match = { class = "^(thet)$" },
    float = true,
    size = { 1600, 1200 },
    workspace = "4 silent",
    no_initial_focus = true,
})

return true
