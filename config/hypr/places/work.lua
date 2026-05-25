hl.monitor({
    output = "DP-1",
    mode = "3840x2160",
    position = "0x50",
    scale = 1.5,
})

hl.monitor({
    output = "DP-2",
    mode = "3840x2160",
    position = "2560x50",
    scale = 1.5,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "3840x2160",
    position = "5120x0",
    scale = 1.5,
    transform = 1,
})

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-1",
    default = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "DP-2",
    default = true,
})

hl.workspace_rule({
    workspace = "3",
    monitor = "HDMI-A-1",
    default = true,
})

hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-2" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "DP-1" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })

hl.env("XCURSOR_SIZE", "40")
hl.env("HYPRCURSOR_SIZE", "40")

hl.config({
    decoration = {
        rounding = 3,
    },

    general = {
        gaps_in = 8,
        gaps_out = 10,
    },
})

return true
