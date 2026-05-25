hl.workspace_rule({
    workspace = "special:magic",
    on_created_empty = "[]",
})

hl.config({
    cursor = {
        inactive_timeout = 15,
        hide_on_key_press = true,
    },

    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 1,
        col = {
            active_border = {
                colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = true,
        hover_icon_on_border = true,
        extend_border_grab_area = 40,
        allow_tearing = false,
        layout = "dwindle",
        snap = {
            enabled = true,
        },
    },

    decoration = {
        rounding = 3,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        dim_inactive = false,
        dim_strength = 0.1,
        dim_special = 0.6,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
        force_split = 2,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = false,
        disable_splash_rendering = false,
        focus_on_activate = true,
    },

    ecosystem = {
        no_donation_nag = true,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 15, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.2, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.6, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.2, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 4.5, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 5.7, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 6, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.2, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.7, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.1, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.5, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.5, bezier = "almostLinear", style = "slidevert" })

return true
