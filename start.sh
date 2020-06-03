#!/bin/bash

test -d /var/run/apache2 || mkdir -p /var/run/apache2
source /etc/apache2/envvars
exec apache2 -D FOREGROUND
