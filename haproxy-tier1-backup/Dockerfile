# Use an official HAProxy image as a parent image.
FROM haproxy:2.6

# Switch to the root user to install packages.
# The base haproxy image runs as a non-root user by default.
USER root

# Install keepalived for high-availability.
# We update the package list and install keepalived without installing recommended packages to keep the image small.
RUN apt-get update && apt-get install -y --no-install-recommends keepalived && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the HAProxy configuration file into the container.
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

# Copy the Keepalived configuration file into the container.
COPY keepalived.conf /etc/keepalived/keepalived.conf

# Copy the entrypoint script, make it executable, and set it as the container's entrypoint.
COPY entrypoint.sh /entrypoint.sh
# Ensure the script has Unix-style line endings (LF) instead of Windows (CRLF).
# This prevents "no such file or directory" errors when running the script.
RUN sed -i 's/\r$//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]