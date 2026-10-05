#!/system/bin/sh
#
# Removing this module deletes the sing-box runsv service folder.
# That folder holds the service definition (run/log/finish/down), the binary
# and the configuration/workdir, so user configuration is removed as well.
# Service logs under /data/adb/runsvdir/log/sv/sing-box are left untouched.
#
rm -rf /data/adb/runsvdir/service/sing-box
