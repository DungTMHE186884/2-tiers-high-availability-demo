FROM haproxy:latest

# Install sudo and keepalived
USER root
RUN apt-get update && \
    apt-get install -y sudo keepalived && \
    rm -rf /var/lib/apt/lists/*

# Copy configurations
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY keepalived.conf /etc/keepalived/keepalived.conf
COPY entrypoint.sh /entrypoint.sh

# Set proper permissions
RUN chmod +x /entrypoint.sh && \
    chown root:root /etc/keepalived/keepalived.conf && \
    chmod 644 /etc/keepalived/keepalived.conf

ENTRYPOINT ["/entrypoint.sh"]