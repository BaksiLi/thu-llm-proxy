FROM openresty/openresty:latest

# Install necessary dependencies (e.g., curl) if needed
RUN apt-get update && apt-get install -y --no-install-recommends curl

# Create directory for custom configurations
RUN mkdir -p /etc/nginx/conf.d

# Copy custom nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Lua script
COPY filter_empty_chunks.lua /usr/local/openresty/nginx/conf/filter_empty_chunks.lua

# Expose port - defined in ENV at docker-compose
ARG PROXY_PORT=11443
ENV PROXY_PORT=${PROXY_PORT}
EXPOSE ${PROXY_PORT}

