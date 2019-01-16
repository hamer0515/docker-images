#!/bin/sh

if [ -n "$SERVER_NAME" ]; then
  sed -i "s%ServerName www.example.com:443%ServerName ${SERVER_NAME}:443%" /etc/apache2/conf.d/ssl.conf
fi

if [ -n "$SSLCertificateFile" ]; then
  sed -i "s%SSLCertificateFile /etc/ssl/apache2/server.pem%SSLCertificateFile ${SSLCertificateFile}%" /etc/apache2/conf.d/ssl.conf
fi

if [ -n "$SSLCertificateKeyFile" ]; then
  sed -i "s%SSLCertificateKeyFile /etc/ssl/apache2/server.key%SSLCertificateKeyFile $SSLCertificateKeyFile%" /etc/apache2/conf.d/ssl.conf
fi

if [ -n "$SVN_REPO" ]; then
  test ! -d "/var/svn/$SVN_REPO" && svnadmin create /var/svn/$SVN_REPO && chgrp -R apache /var/svn/$SVN_REPO && chmod -R 775 /var/svn/$SVN_REPO
  echo "Creating the repository: $SVN_REPO into /var/svn/"
else
  test ! -d "/var/svn/repo" && svnadmin create /var/svn/repo && chgrp -R apache /var/svn/repo && chmod -R 775 /var/svn/repo
  echo "Warning: SVN_REPO variable not defined, starting with svn default repository: repo into /var/svn/"
fi

if [ -n "$SVN_USER" ] && [ -n "$SVN_PASS" ]; then
  htpasswd -bc /var/svn/svn_http_passwd $SVN_USER $SVN_PASS
else
  htpasswd -bc /var/svn/svn_http_passwd svn svn
  echo "Warning: SVN_USER / SVN_PASS variables not defined, starting with default account"
fi

httpd -D FOREGROUND