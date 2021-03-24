FROM php:7.0-apache
COPY src/ /var/www/html
EXPOSE 80:80
RUN \
  curl -L https://download.newrelic.com/php_agent/release/newrelic-php5-9.16.0.295-linux.tar.gz | tar -C /tmp -zx && \
  export NR_INSTALL_USE_CP_NOT_LN=1 && \
  export NR_INSTALL_SILENT=1 && \
  /tmp/newrelic-php5-*/newrelic-install install && \
  rm -rf /tmp/newrelic-php5-* /tmp/nrinstall* && \
  sed -i \
      -e 's/"REPLACE_WITH_REAL_KEY"/""/' \
      -e 's/newrelic.appname = "PHP Application"/newrelic.appname = "JordanTestPHP"/' \
      -e 's/;newrelic.daemon.app_connect_timeout =.*/newrelic.daemon.app_connect_timeout=15s/' \
      -e 's/;newrelic.daemon.start_timeout =.*/newrelic.daemon.start_timeout=5s/' \
      /usr/local/etc/php/conf.d/newrelic.ini

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]