-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Start the primary browser and reattach the persistent Herdr session on
-- their dedicated workspaces.  Use Hyprland's exec rules directly so the
-- workspace assignment is preserved instead of being parsed by uwsm-app.
o.exec_on_start("sleep 3 && hyprctl dispatch exec '[workspace 1 silent] chromium'")
o.exec_on_start("sleep 4 && hyprctl dispatch exec '[workspace 2 silent] ghostty -e herdr'")
