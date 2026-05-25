hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- swaybg -i ~/.config/system-setup/current/background -m fill")
    hl.exec_cmd("uwsm app -- waybar")
end)

return true
