#!/usr/bin/env bash
 
# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"
 
# VARIABLES ####################################################################
echo -e "-- Setting global variables\n"
APACHE_CONFIG=/etc/apache2/apache2.conf
VIRTUAL_HOST=localhost
DOCUMENT_ROOT=/var/www/html
 
# BOX ##########################################################################
echo -e "-- Updating packages list\n"
apt-get update -y -qq
 
# APACHE #######################################################################
echo -e "-- Installing Apache web server\n"
apt-get install -y apache2
 
echo -e "-- Adding ServerName to Apache config\n"
grep -q "ServerName ${VIRTUAL_HOST}" "${APACHE_CONFIG}" || echo "ServerName ${VIRTUAL_HOST}" >> "${APACHE_CONFIG}"
 
echo -e "-- Allowing Apache override to all\n"
sed -i "s/AllowOverride None/AllowOverride All/g" ${APACHE_CONFIG}
 
echo -e "-- Updating vhost file\n"
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
    ServerName ${VIRTUAL_HOST}
    DocumentRoot ${DOCUMENT_ROOT}
 
    <Directory ${DOCUMENT_ROOT}>
        Options Indexes FollowSymlinks
        AllowOverride All
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>
 
    ErrorLog ${APACHE_LOG_DIR}/${VIRTUAL_HOST}-error.log
    CustomLog ${APACHE_LOG_DIR}/${VIRTUAL_HOST}-access.log combined
</VirtualHost>
EOF
 
echo -e "-- Restarting Apache web server\n"
service apache2 restart
 
# TEST #########################################################################
echo -e "-- Creating a dummy index.html file\n"
cat > ${DOCUMENT_ROOT}/index.html <<EOD
<html>
<head>
<title>${HOSTNAME}</title>
</head>
<body>
<h1>${HOSTNAME}</h1>
<p>This is the landing page for <b>${HOSTNAME}</b>.</p>
</body>
</html>
EOD
 
# END ##########################################################################
echo -e "-- ---------------- --"
echo -e "-- END BOOTSTRAPING --"
echo -e "-- ---------------- --"
