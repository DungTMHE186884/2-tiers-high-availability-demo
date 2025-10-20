#!/bin/sh

# Ensure proper permissions
chmod 644 /etc/keepalived/keepalived.conf
chown root:root /etc/keepalived/keepalived.conf

# Start haproxy in the background
haproxy -f /usr/local/etc/haproxy/haproxy.cfg &

# Start keepalived in the foreground with proper permissions
exec keepalived --dont-fork --log-console