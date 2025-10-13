FROM haproxy:latest

# Install Keepalived and process tools
RUN apt-get update && apt-get install -y keepalived procps

# Copy the entrypoint script that will start both services
COPY --chmod=755 entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]