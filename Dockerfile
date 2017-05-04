FROM hypriot/rpi-alpine
MAINTAINER julien Ancelin
RUN apk --update add xauth htop curl apache2 apache2-utils apache-mod-fcgid php5-fpm php5-cgi php5-gd php5-sqlite3 php5-curl php5-xmlrpc \
                 py-simplejson vim ca-certificates unzip \
                 && rm -f /var/cache/apk/*

ENV LIZMAPVERSION 3.1.1

COPY filesAlpine/ /home/files/

ADD https://github.com/3liz/lizmap-web-client/archive/$LIZMAPVERSION.zip /var/www/
RUN  chmod +x /home/files/setup.sh && \
     sh /home/files/setup.sh
    
VOLUME  ["/var/www/websig/lizmap/var" , "/home"] 
EXPOSE 80 443
#CMD /start.sh

