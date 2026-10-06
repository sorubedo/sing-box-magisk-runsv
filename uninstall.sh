#!/system/bin/sh
#
# Removing this module deletes the sing-box runsv service folder.
# That folder holds the service definition (run/log/finish/down), the
# configuration/workdir and (for the nomount variant) the binary copy, so user
# configuration is removed as well. The mount variant's core binary lives in
# the module's system/bin and is removed automatically by the manager.
# Service logs under /data/adb/runsvdir/log/sv/sing-box are left untouched.
#
rm -rf /data/adb/runsvdir/service/sing-box
