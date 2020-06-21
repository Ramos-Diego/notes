#!/bin/bash

#To schedule with crontab run these command as root
# $ crontab -e
#And paste this:
# Check if the certificate needs to be renewed everyday at 3AM.
# 0 3 * * * certbot renew --pre-hook "systemctl stop nginx" --post-hook "systemctl restart nginx"

# Renew SSL certificates
certbot renew --pre-hook "systemctl stop nginx" --post-hook "systemctl restart nginx"
# This script assumes your autheticator = standalone
# Check your certbot config at /etc/letsencrypt/renewal/<insert-domain.com>.conf

# THIS WILL RUN EVEN IF CERT ISN'T RENEWED
cd /etc/

# Backup SSL certificates (SAFETY FIRST)
# Compress and zip /letsencrypt directory and move zipped file to safe location
tar czf SSL_BACKUP.tar.gz letsencrypt/ && mv SSL_BACKUP.tar.gz /home/mike && rm -f SSL_BACKUP.tar.gz
