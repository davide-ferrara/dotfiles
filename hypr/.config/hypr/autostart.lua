-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Start the primary browser and reattach the persistent Herdr session after
-- UWSM's app daemon is ready. Native window rules keep the workspace
-- assignment independent of process-launch timing.
hl.window_rule({ match = { initial_class = "chromium" }, workspace = "1 silent" })
hl.window_rule({ match = { initial_class = "com.mitchellh.ghostty" }, workspace = "2 silent" })

o.exec_on_start("sleep 3 && uwsm-app -- chromium")
o.exec_on_start("sleep 4 && uwsm-app -- ghostty -e herdr")
