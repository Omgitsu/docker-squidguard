FROM sameersbn/squid:3.5.27-2
MAINTAINER derk@muenchhausen.de

RUN echo "Dockerfile init"

RUN apt-get update \
 && apt-get install -y apt-utils \
 && apt-get install -y squidguard \ 
 && apt-get install -y curl \
 && apt-get install -y sudo \
 && apt-get install -y nano \
 && apt-get install -y apache2

RUN echo 'AddType application/x-ns-proxy-autoconfig .dat' >> /etc/apache2/httpd.conf
ADD config/wpad.dat /var/www/html/wpad.dat
# for backward compatibility add it also with typo ;)
ADD config/wpad.dat /var/www/html/wpat.dat
ADD config/block.html /var/www/html/block.html

# copy stuff over
RUN rm /sbin/entrypoint.sh
ADD config/entrypoint.sh /sbin/entrypoint.sh
RUN rm /etc/squid/squid.conf
ADD config/squid.conf.3.5.27 /etc/squid/squid.conf

# RUN echo "redirect_program /usr/bin/squidGuard -c /etc/squidguard/squidGuard.conf" >> /etc/squid/squid.conf

RUN rm /etc/squidguard/squidGuard.conf
# ADD sample-config-blacklist /sample-config-blacklist
# ADD sample-config-simple /sample-config-simple
RUN mkdir /config

ADD startSquidGuard /startSquidGuard
RUN chmod a+x /startSquidGuard

EXPOSE 3128 80
VOLUME ["/var/log/squid"]
VOLUME ["/config"]

CMD ["/startSquidGuard"]
