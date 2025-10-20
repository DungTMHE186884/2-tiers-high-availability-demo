#!/bin/sh

# Set correct ownership and permissions for the Keepalived configuration file.
# This is a good practice for security and to ensure the service can read its config.
chmod 644 /etc/keepalived/keepalived.conf
chown root:root /etc/keepalived/keepalived.conf

# Start the HAProxy service in the background (&) so the script can continue.
haproxy -f /usr/local/etc/haproxy/haproxy.cfg &

# Start Keepalived in the foreground. This is the main process for the container.
# --dont-fork prevents it from becoming a daemon, which is standard for container entrypoints.
# --log-console sends logs to stdout/stderr so 'docker logs' can capture them.
exec keepalived --dont-fork --log-console