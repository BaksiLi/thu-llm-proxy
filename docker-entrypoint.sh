#!/bin/sh
set -e

# Create necessary directories
mkdir -p /tmp/nginx/conf.d
mkdir -p /tmp/nginx/logs

# Set default values for environment variables if not provided
export PROXY_PORT=${PROXY_PORT:-11443}
export HOST_ADDRESS=${HOST_ADDRESS:-localhost}

# Debug: Print the values being used
echo "Using PROXY_PORT: $PROXY_PORT"
echo "Using HOST_ADDRESS: $HOST_ADDRESS"

# Process the nginx configuration with environment variables
envsubst '${PROXY_PORT} ${HOST_ADDRESS}' < /etc/nginx/conf.d/default.conf > /tmp/nginx/conf.d/default.conf

# Copy other necessary files
cp /usr/local/openresty/nginx/conf/mime.types /tmp/nginx/mime.types
cp /etc/nginx/nginx.conf /tmp/nginx/nginx.conf

# Verify the substitution worked
#echo "Processed nginx configuration:"
#cat /tmp/nginx/conf.d/default.conf

# Start OpenResty with the processed configuration
exec /usr/local/openresty/bin/openresty -p /tmp/nginx -c /tmp/nginx/nginx.conf -g "daemon off;"