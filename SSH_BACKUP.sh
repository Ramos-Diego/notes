#!/bin/bash
cd /etc/

# Backup SSL certificates (SAFETY FIRST)
# Compress and zip /letsencrypt directory and move zipped file to safe location
tar czf SSL_BACKUP.tar.gz letsencrypt/ && mv SSL_BACKUP.tar.gz /home/mike && rm -f SSL_BACKUP.tar.gz