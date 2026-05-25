local source = debug.getinfo(1, "S").source
local config_path = source:sub(1, 1) == "@" and source:sub(2) or source
local config_dir = config_path:match("(.*/)")

if config_dir then
    package.path = config_dir .. "?.lua;" .. config_dir .. "?/init.lua;" .. package.path
end

local helpers = require("helpers")
local settings = require("settings")
local safe_require = helpers.safe_require

local terminal = settings.terminal
local browser = settings.browser
local webapp = settings.webapp
local mainMod = settings.mainMod

local hostname = os.getenv("HOSTNAME") or ""
if hostname == "" then
    local f = io.open("/etc/hostname", "r")
    if f then
        hostname = (f:read("*l") or ""):match("^%s*(.-)%s*$")
        f:close()
    end
end

local host_profiles = {
    holodeck = "home",
}

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "altgr-intl",
        kb_model = "",
        kb_options = "ctrl:nocaps",
        kb_rules = "",
        follow_mouse = 1,
        repeat_rate = 30,
        repeat_delay = 600,
        sensitivity = 1.0,
        touchpad = {
            natural_scroll = false,
            disable_while_typing = true,
            scroll_factor = 1.0,
            tap_to_click = true,
        },
    },
})

require("envs")
require("autostart")
require("looknfeel")
require("windows")
require("bindings")

local active_profile = host_profiles[hostname] -- Or set this directly to "home", "laptop", or "work".
if active_profile then
    safe_require("places." .. active_profile)
end

safe_require("dms.outputs")
require("dank")

hl.config({
    debug = {
        suppress_errors = true,
    },
})

return {
    terminal = terminal,
    browser = browser,
    webapp = webapp,
    mainMod = mainMod,
}
