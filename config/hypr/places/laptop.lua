hl.env("GDK_SCALE", "1")

hl.monitor({
    output = "eDP-1",
    mode = "highres@highrr",
    position = "0x0",
    scale = 1,
})

hl.workspace_rule({
    workspace = "1",
    monitor = "eDP-1",
    default = true,
})

hl.config({
    debug = {
        vfr = true,
    },

    decoration = {
        blur = {
            enabled = false,
        },
    },

    general = {
        gaps_in = 6,
        gaps_out = 6,
        border_size = 1,
        layout = "scrolling",
    },
})

hl.window_rule({
    name = "thet-debug",
    match = { class = "thet" },
    no_initial_focus = true,
    workspace = "3",
    float = true,
    size = { "monitor_w*0.72", "monitor_h*0.78" },
})

hl.window_rule({
    name = "com.example.my_proj",
    match = { class = "com.example.my_proj" },
    no_initial_focus = true,
    workspace = "3",
    float = true,
    size = { "monitor_w*0.72", "monitor_h*0.78" },
})

return true
