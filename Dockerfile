FROM openresty/openresty:latest

# Install necessary dependencies
RUN apt-get update && apt-get install -y --no-install-recommends curl gettext-base

# Create directory for custom configurations
RUN mkdir -p /etc/nginx/conf.d

# Expose port - defined in ENV at docker-compose
ARG PROXY_PORT=11443
ENV PROXY_PORT=${PROXY_PORT}
EXPOSE ${PROXY_PORT}

# Add an entrypoint script to handle environment variable substitution
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

