#!/bin/bash

# Update system packages
yum update -y

# Install Apache
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Install PHP and required extensions
amazon-linux-extras enable php8.2
yum clean metadata
yum install -y php php-mysqlnd php-fpm php-xml php-mbstring php-cli unzip git

# Download and extract WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# Configure wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_user}/" wp-config.php
sed -i "s/password_here/${db_user_password}/" wp-config.php
sed -i "s/localhost/${db_host}/" wp-config.php

# Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
systemctl restart httpd

# Clone and copy theme
git clone https://github.com/emrekaraat/wordpress-content.git /tmp/wp-content
cp -r /tmp/wp-content/* /var/www/html/
cp /tmp/wp-content/wp-content/themes/emre-theme/page-myproject.php /var/www/html/wp-content/themes/twentytwentyfive/page-myproject.php

# Install WP-CLI
cd /home/ec2-user
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Inject Galatasaray content
cat <<EOF > /tmp/galatasaray_content.html
${galatasaray_content}
EOF

# Install WordPress and create page with content
cd /var/www/html
wp core install \
  --url="http://localhost" \
  --title="Capstone Project" \
  --admin_user=admin \
  --admin_password=Test987# \
  --admin_email="${notification_email}" \
  --skip-email \
  --allow-root

# Create WordPress page with content directly
wp post create \
  --post_type=page \
  --post_title="My Project" \
  --post_status=publish \
  --page_template=page-myproject.php \
  --post_name="myproject" \
  --post_content="$(</tmp/galatasaray_content.html)" \
  --allow-root

# Create phpinfo test page
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
