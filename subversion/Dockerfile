FROM alpine:3.8

COPY startup.sh /
COPY vh-davsvn.conf /etc/apache2/conf.d/

RUN apk --update add --no-cache apache2 apache2-utils apache2-webdav apache2-ssl mod_dav_svn subversion && \
    mkdir -p /run/apache2 && \
    chmod +x /startup.sh

EXPOSE 80 443

VOLUME ["/var/svn"]

CMD ["/startup.sh"]
