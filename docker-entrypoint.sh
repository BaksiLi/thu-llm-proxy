#!/bin/bash
set -e

# Create necessary directories
mkdir -p /tmp/nginx/conf.d
mkdir -p /tmp/nginx/logs

# Set default values for environment variables if not provided
export PROXY_PORT=${PROXY_PORT:-11443}
export HOST_ADDRESS=${HOST_ADDRESS:-localhost}
export ALLOWLIST_CONFIG=${ALLOWLIST_CONFIG:-""}

# Print the values being used
echo "Using PROXY_PORT: $PROXY_PORT"
echo "Using HOST_ADDRESS: $HOST_ADDRESS"

# Process the nginx configuration for PROXY_PORT and HOST_ADDRESS
envsubst '${PROXY_PORT} ${HOST_ADDRESS}' < /etc/nginx/conf.d/default.conf > /tmp/nginx/conf.d/default.conf.tmp

# Handle ALLOWLIST_CONFIG separately
if [ -z "$ALLOWLIST_CONFIG" ] || [ "${ALLOWLIST_CONFIG:0:1}" = "#" ]; then
    # If empty or starts with #, we'll disable the allowlist by removing the line
    sed "s|\${ALLOWLIST_CONFIG}||g" /tmp/nginx/conf.d/default.conf.tmp > /tmp/nginx/conf.d/default.conf
    echo "IP allowlist disabled"
else
    # Replace the variable with the actual config
    sed "s|\${ALLOWLIST_CONFIG}|$ALLOWLIST_CONFIG|g" /tmp/nginx/conf.d/default.conf.tmp > /tmp/nginx/conf.d/default.conf
    echo "IP allowlist enabled with: $ALLOWLIST_CONFIG"
fi

rm /tmp/nginx/conf.d/default.conf.tmp

# Copy other necessary files
cp /usr/local/openresty/nginx/conf/mime.types /tmp/nginx/mime.types
cp /etc/nginx/nginx.conf /tmp/nginx/nginx.conf

# Start OpenResty with the processed configuration
exec /usr/local/openresty/bin/openresty -p /tmp/nginx -c /tmp/nginx/nginx.conf -g "daemon off;"