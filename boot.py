# Avoid reboot loop on longer runtime
import supervisor
supervisor.runtime.autoreload = False
