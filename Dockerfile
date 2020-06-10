FROM debian:buster
MAINTAINER Alessio Ligabue <info@alessioligabue.it>

## Install base packages
RUN apt update && \
    apt install -qqy \
		apache2 \
		curl \
		wget \
		apt-transport-https \
		gnupg \
		ca-certificates && \
		php \
		php-pear \
	apt autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb -O /tmp/pagespeed.deb
RUN dpkg -i /tmp/pagespeed.deb
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
RUN a2dismod php* mpm_prefork
RUN a2enmod mpm_event proxy_fcgi rewrite http2 headers brotli expires

ADD start.sh /root/start.sh
RUN chmod 755 /root/start.sh && chown -R www-data:www-data /var/www/html

EXPOSE 80 443
ENTRYPOINT ["/root/start.sh"]
