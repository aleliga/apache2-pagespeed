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
		ca-certificates \
		php \
		unzip \
		apache2-dev \
		php-pear && \
	apt autoclean

RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb -O /tmp/pagespeed.deb
RUN dpkg -i /tmp/pagespeed.deb
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
RUN a2dismod php* 
RUN a2dismod mpm_prefork
RUN wget https://github.com/cloudflare/mod_cloudflare/archive/refs/heads/master.zip  -O /tmp/cf-master.zip
RUN unzip /tmp/cf-master.zip -d /tmp
RUN apxs2 -a -i -c /tmp/mod_cloudflare-master/mod_cloudflare.c
RUN a2enmod mpm_event proxy_fcgi rewrite http2 headers brotli expires remoteip
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

ADD start.sh /root/start.sh
RUN chmod 755 /root/start.sh && chown -R www-data:www-data /var/www/html

EXPOSE 80 443
ENTRYPOINT ["/root/start.sh"]
