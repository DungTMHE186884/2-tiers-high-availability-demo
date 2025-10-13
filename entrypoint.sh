#!/bin/sh

# Start haproxy in the background
haproxy -f /usr/local/etc/haproxy/haproxy.cfg &

# Start keepalived in the foreground, logging to console
keepalived --dont-fork --log-console