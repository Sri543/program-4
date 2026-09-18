#!/bin/bash

# SELinux Access Denial Practical
# Student Name:
# Register Number:

echo "===== SELinux Status ====="
sestatus

echo "===== Creating Web Directory ====="
sudo mkdir -p /var/www/html/test_app
echo "===== Creating HTML File ====="
sudo mkdir -p /var/www/html/test_app

echo "===== Setting Linux Permissions ====="
sudo chmod -R 755 /var/www/html/test_app
sudo chown -R apache:apache /var/www/html/test_app 2>/dev/null || sudo chown -R www-data:www-data /var/www/html/test_app

echo "===== Checking Initial Context ====="
ls -Z /var/www/html/test_app/index.html

echo "===== Assigning Wrong SELinux Context ====="
sudo chcon -t user_home_t /var/www/html/test_app/index.html
echo "===== Checking Wrong Context ====="
ls -Z /var/www/html/test_app/index.html

echo "===== Checking AVC Denials ====="
curl http://localhost/test_app/index.html 2>/dev/null
sudo ausearch -m avc -ts recent 2>/dev/null || sudo grep "SELinux is preventing" /var/log/messages | tail -n 5
echo "===== Correcting SELinux Context ====="
sudo restorecon -v /var/www/html/test_app/index.html
echo "===== Checking Correct Context ====="
ls -Z /var/www/html/test_app/index.html

echo "===== Practical Completed ====="
