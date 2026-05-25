local helpers = require("helpers")
local safe_require = helpers.safe_require

hl.bind("SUPER + code:65", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
hl.bind("SUPER + Comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("dms ipc call lock lock"))

hl.bind("Print", hl.dsp.exec_cmd("dms ipc call screenshot capture"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms ipc call screenshot captureScreen"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("dms ipc call screenshot captureWindow"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer --allow-boost --increase 3"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer --allow-boost --decrease 3"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true })

hl.window_rule({
    name = "dms-quickshell",
    match = { class = "org.quickshell" },
    float = true,
})

safe_require("dms.colors")
safe_require("dms.layout")
safe_require("dms.cursor")

return true
