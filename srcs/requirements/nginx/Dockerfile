# Start from Debian
FROM debian:bullseye

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install nginx and openssl
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt-get/lists/*

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed cert with TLSv1.3 support
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/self.key \
    -out /etc/nginx/ssl/self.crt \
    -subj "/C=FR/ST=42/L=Paris/O=42/CN=aprevrha.42.fr"

# Copy nginx config and web content
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Expose HTTPS port
EXPOSE 443

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]