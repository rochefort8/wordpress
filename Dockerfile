FROM tutum/lamp:latest
MAINTAINER Fernando Mayo <fernando@tutum.co>, Feng Honglin <hfeng@tutum.co>

# Install plugins
RUN apt-get update && \
  apt-get -y install php5-gd && \
  rm -rf /var/lib/apt/lists/*

# Download latest version of Wordpress into /app
RUN rm -fr /app && git clone --depth=1 https://github.com/WordPress/WordPress.git /app

# Download "Search Replace DB"
RUN git clone --depth=1 https://github.com/interconnectit/Search-Replace-DB.git /app/SR

ADD ./wp-content /app/wp-content
ADD .htaccess /app/

# Configure Wordpress to connect to local DB
ADD wp-config.php /app/wp-config.php

# Modify permissions to allow plugin upload
RUN chown -R www-data:www-data /app/wp-content /var/www/html

# Add database setup script
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh

ADD mysql.dump.sql /mysql.dump.sql

ADD create_db.sh /create_db.sh
RUN chmod +x /*.sh

# More updates
ADD system/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80 3306
CMD ["/run.sh"]
