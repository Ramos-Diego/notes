#!/bin/bash

# Renew SSL certificates
certbot renew --pre-hook "systemctl stop nginx" --post-hook "systemctl restart nginx"
# This script assumes your autheticator = standalone
# Check your certbot config at /etc/letsencrypt/renewal/<insert-domain.com>.conf

# Backup SSL certificates (SAFETY FIRST)
# Compress and zip /letsencrypt directory
tar czf <insert-domain.com>.tar.gz /etc/letsencrypt/

# Move zipped file to safe location
mv <insert-domain.com>.tar.gz /path/to/safety/ && rm <insert-domain.com>.tar.gz