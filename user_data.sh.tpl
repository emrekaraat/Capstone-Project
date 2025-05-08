#!/bin/bash

# [System Update] Update all installed packages
echo "[Start] Updating system packages"
yum update -y

# [Web Server] Install and start Apache
echo "[Step 1] Installing Apache"
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# [PHP] Enable PHP 8.2 and install necessary extensions
echo "[Step 2] Installing PHP and extensions"
amazon-linux-extras enable php8.2
yum clean metadata
yum install -y php php-mysqlnd php-fpm php-xml php-mbstring php-cli unzip

# [WordPress] Download and install WordPress
echo "[Step 3] Installing WordPress"
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# [Config] Create wp-config.php and set DB credentials
echo "[Step 4] Configuring wp-config.php"
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_user}/" wp-config.php
sed -i "s/password_here/${db_user_password}/" wp-config.php
sed -i "s/localhost/${db_host}/" wp-config.php

# [Permissions] Set ownership and restart Apache
echo "[Step 5] Setting permissions"
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
systemctl restart httpd

# [Custom Theme] Clone theme and template files from GitHub
echo "[Step 6] Cloning WordPress content"
yum install -y git
git clone https://github.com/emrekaraat/wordpress-content.git /tmp/wp-content
cp -r /tmp/wp-content/* /var/www/html/
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# [Custom Page Template] Copy custom page template to theme directory
echo "[Step 7] Copying custom page template"
cp /tmp/wp-content/wp-content/themes/emre-theme/page-myproject.php /var/www/html/wp-content/themes/twentytwentyfive/page-myproject.php

# [WP-CLI] Install WP-CLI for WordPress command line management
echo "[Step 8] Installing WP-CLI"
cd /home/ec2-user
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# [Install WordPress] Using WP-CLI
echo "[Step 9] Installing WordPress via WP-CLI"
cd /var/www/html
wp core install \
  --url="http://localhost" \
  --title="Capstone Project" \
  --admin_user=admin \
  --admin_password=Test987# \
  --admin_email="${notification_email}" \
  --skip-email \
  --allow-root

# [Create Page] Create initial 'My Project' page
echo "[Step 10] Creating initial placeholder page"
wp post create \
  --post_type=page \
  --post_title="My Project" \
  --post_status=publish \
  --page_template=page-myproject.php \
  --post_name="myproject" \
  --allow-root

# [Inject Galatasaray Content] Pull content from GitHub and update the page
echo "[Step 11] Fetching Galatasaray HTML content"
curl -o /tmp/galatasaray_content.html https://raw.githubusercontent.com/emrekaraat/galatasaray/main/galatasaray_content.html

page_id=$(wp post list --post_type=page --name="myproject" --field=ID --allow-root)
wp post update "$page_id" --post_content="$(cat /tmp/galatasaray_content.html)" --allow-root

# [Health Check] Confirm Apache is running
echo "[HealthCheck] Verifying Apache"
curl -s http://localhost > /dev/null && echo "Apache is responding." || echo "Apache not responding!"

# [Debug Page] Create phpinfo test page
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
