#!/bin/bash

# 1. Update all system packages
yum update -y

# 2. Install Apache (httpd)
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# 3. Install PHP and required extensions
amazon-linux-extras enable php8.2
yum clean metadata
yum install -y php php-mysqlnd php-fpm php-xml php-mbstring

# 4. Install and start MariaDB (MySQL server)
yum install -y mariadb105-server
systemctl start mariadb
systemctl enable mariadb

# 5. Secure MariaDB and create WordPress database and user
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY "${db_root_password}";
CREATE DATABASE wordpress;
CREATE USER '${db_user}'@'localhost' IDENTIFIED BY "${db_user_password}";
GRANT ALL PRIVILEGES ON wordpress.* TO '${db_user}'@'localhost';
FLUSH PRIVILEGES;
EOF

# 6. Download and install WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# 7. Generate wp-config.php automatically
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/${db_user}/" wp-config.php
sed -i "s/password_here/${db_user_password}/" wp-config.php

# 8. Set file ownership and permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# 9. Restart Apache service
systemctl restart httpd

# 10. Create a PHP info test page
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
