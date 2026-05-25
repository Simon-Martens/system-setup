local settings = require("settings")

local terminal = settings.terminal
local browser = settings.browser
local mainMod = settings.mainMod

local function bind_workspace_swap(keys, swap_cmd, focus_cmd)
    hl.bind(keys, function()
        hl.dispatch(hl.dsp.exec_cmd(swap_cmd))
        hl.dispatch(hl.dsp.exec_cmd(focus_cmd))
    end)
end

local function cycle_workspace_on_current_monitor(step)
    local monitor = hl.get_active_monitor()
    if not monitor then
        return
    end

    local current = hl.get_active_workspace(monitor)
    if not current then
        return
    end

    local workspaces = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        if not ws.special and ws.monitor and ws.monitor.id == monitor.id then
            workspaces[#workspaces + 1] = ws
        end
    end

    table.sort(workspaces, function(a, b)
        return a.id < b.id
    end)

    if #workspaces == 0 then
        return
    end

    local index = 1
    for i, ws in ipairs(workspaces) do
        if ws.id == current.id then
            index = i
            break
        end
    end

    if step > 0 and index == #workspaces then
        hl.dispatch(hl.dsp.focus({ workspace = "emptynm" }))
        return
    end

    local next_index = ((index - 1 + step) % #workspaces) + 1
    hl.dispatch(hl.dsp.focus({ workspace = workspaces[next_index].id }))
end

hl.config({
    binds = {
        hide_special_on_workspace_change = true,
    },

    gestures = {
        workspace_swipe_min_speed_to_force = 20,
        workspace_swipe_distance = 200,
        workspace_swipe_create_new = true,
        workspace_swipe_invert = false,
    },
})

hl.gesture({
    fingers = 4,
    direction = "vertical",
    action = "workspace",
})

hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
})

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus --new-window"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(terminal .. " -e btop"))

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("uwsm app -- ~/.local/share/system-setup/bin/hyprland-minimizer"))

hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.swap({ direction = "d" }))

bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + left",
    "hyprctl dispatch swapactiveworkspaces l 0",
    "hyprctl dispatch focuswindow l"
)
bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + right",
    "hyprctl dispatch swapactiveworkspaces r 0",
    "hyprctl dispatch focuswindow r"
)
bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + up",
    "hyprctl dispatch swapactiveworkspaces u 0",
    "hyprctl dispatch focuswindow u"
)
bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + down",
    "hyprctl dispatch swapactiveworkspaces d 0",
    "hyprctl dispatch focuswindow d"
)
bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + H",
    "hyprctl dispatch swapactiveworkspaces current l",
    "hyprctl dispatch focusmonitor l"
)
bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + L",
    "hyprctl dispatch swapactiveworkspaces current r",
    "hyprctl dispatch focusmonitor r"
)
bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + J",
    "hyprctl dispatch swapactiveworkspaces current d",
    "hyprctl dispatch focusmonitor d"
)
bind_workspace_swap(
    mainMod .. " + CTRL + SHIFT + K",
    "hyprctl dispatch swapactiveworkspaces current u",
    "hyprctl dispatch focusmonitor u"
)

hl.bind(mainMod .. " + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind(mainMod .. " + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.exec_cmd("~/.config/hypr/scripts/adjust-monitor-scale.sh down"))
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.exec_cmd("~/.config/hypr/scripts/adjust-monitor-scale.sh up"))

hl.bind(mainMod .. " + X", function()
    cycle_workspace_on_current_monitor(1)
end)
hl.bind(mainMod .. " + Z", function()
    cycle_workspace_on_current_monitor(-1)
end)

hl.bind(mainMod .. " + SHIFT + X", function()
    hl.dispatch(hl.dsp.window.move({ workspace = "+1" }))
end)
hl.bind(mainMod .. " + SHIFT + Z", function()
    hl.dispatch(hl.dsp.window.move({ workspace = "-1" }))
end)
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind("ALT + TAB", hl.dsp.exec_raw("cyclenext visible hist"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

return true
