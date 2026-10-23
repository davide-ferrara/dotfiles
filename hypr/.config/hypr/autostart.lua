-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Start the primary browser and reattach the persistent Herdr session after
-- UWSM's app daemon is ready. Keep the browser on workspace 1, but let new
-- terminal windows open on whichever workspace is active.
hl.window_rule({ match = { initial_class = "zen" }, workspace = "1 silent" })

o.exec_on_start("sleep 3 && omarchy-launch-browser")
o.exec_on_start("sleep 4 && uwsm-app -- ghostty -e herdr")
