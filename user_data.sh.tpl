#!/bin/bash

echo "[Start] Updating system packages"
yum update -y                                # Update all installed system packages

echo "[Step 1] Installing Apache (httpd)"
yum install -y httpd                         # Install Apache web server
systemctl start httpd                        # Start Apache service
systemctl enable httpd                       # Enable Apache to start on boot

echo "[Step 2] Installing PHP and required extensions"
amazon-linux-extras enable php8.2           # Enable PHP 8.2 from Amazon Linux Extras
yum clean metadata                          # Clean YUM metadata
yum install -y php php-mysqlnd php-fpm php-xml php-mbstring  # Install PHP and modules

echo "[Step 3] Installing MariaDB locally (optional)"
yum install -y mariadb105-server             # Install MariaDB (optional local DB for testing)
systemctl start mariadb                      # Start MariaDB
systemctl enable mariadb                     # Enable MariaDB to start on boot

echo "[Step 4] Configuring local test DB"
mysql -u root <<EOF                          # Configure a test DB and user credentials
ALTER USER 'root'@'localhost' IDENTIFIED BY "${db_root_password}";
CREATE DATABASE local_test_db;
CREATE USER '${db_user}'@'localhost' IDENTIFIED BY "${db_user_password}";
GRANT ALL PRIVILEGES ON local_test_db.* TO '${db_user}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[Step 5] Downloading and installing WordPress"
cd /var/www/html                             # Navigate to web root
wget https://wordpress.org/latest.tar.gz     # Download latest WordPress
tar -xzf latest.tar.gz                       # Extract archive
cp -r wordpress/* .                          # Move files to web root
rm -rf wordpress latest.tar.gz               # Clean up

echo "[Step 6] Configuring wp-config.php"
cp wp-config-sample.php wp-config.php        # Copy sample config
sed -i "s/database_name_here/${db_name}/" wp-config.php      # Set DB name
sed -i "s/username_here/${db_user}/" wp-config.php           # Set DB user
sed -i "s/password_here/${db_user_password}/" wp-config.php  # Set DB password
sed -i "s/localhost/${db_host}/" wp-config.php               # Set DB host (usually RDS)

echo "[Step 7] Setting permissions and restarting Apache"
chown -R apache:apache /var/www/html         # Set ownership to Apache user
chmod -R 755 /var/www/html                   # Set permissions
systemctl restart httpd                      # Restart Apache to apply changes

sleep 10                                     # Give Apache time to fully start

# ✅ Check if Apache is responding (important for ALB health checks)
curl -s http://localhost > /dev/null && echo "[HealthCheck] Apache is responding." || echo "[HealthCheck] Apache not responding!"

echo "<?php phpinfo(); ?>" > /var/www/html/info.php  # Add test PHP info page

# ℹ️ CloudWatch Agent was disabled due to IAM restrictions
