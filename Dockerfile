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
	apt autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb -O /tmp/pagespeed.deb
RUN dpkg -i /tmp/pagespeed.deb
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13

#ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD start.sh /root/start.sh
RUN chmod 755 /root/start.sh && chown -R www-data:www-data /var/www/html

EXPOSE 80 443
ENTRYPOINT ["/root/start.sh"]
