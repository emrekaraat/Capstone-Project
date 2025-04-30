#!/bin/bash

# 1. Update system
yum update -y

# 2. Install Apache
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# 3. Install PHP and required extensions
amazon-linux-extras enable php8.2
yum clean metadata
yum install -y php php-mysqlnd php-fpm php-xml php-mbstring

# 4. Install MariaDB locally (optional fallback)
yum install -y mariadb105-server
systemctl start mariadb
systemctl enable mariadb

# 5. Configure local test DB (not used by WordPress)
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY "${db_root_password}";
CREATE DATABASE local_test_db;
CREATE USER '${db_user}'@'localhost' IDENTIFIED BY "${db_user_password}";
GRANT ALL PRIVILEGES ON local_test_db.* TO '${db_user}'@'localhost';
FLUSH PRIVILEGES;
EOF

# 6. Install WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# 7. Configure wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_user}/" wp-config.php
sed -i "s/password_here/${db_user_password}/" wp-config.php
sed -i "s/localhost/${db_host}/" wp-config.php

# 8. Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
systemctl restart httpd

# 9. PHP info test page
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# CloudWatch Agent was disabled due to IAM restrictions in the current environment
