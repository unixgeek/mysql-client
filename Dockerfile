FROM debian:bookworm-20240722-slim

RUN apt-get update \
    && apt-get install --yes --no-install-recommends curl ca-certificates \
    && curl --location --remote-name https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-client_8.0.39-1debian12_amd64.deb  \
    && curl --location --remote-name https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-client-core_8.0.39-1debian12_amd64.deb \
    && curl --location --remote-name https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-client-plugins_8.0.39-1debian12_amd64.deb \
    && curl --location --remote-name https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-common_8.0.39-1debian12_amd64.deb \
    && dpkg -i *.deb \
    && apt-get purge --yes curl ca-certificates \
    && apt-get autoremove --yes

ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=default
ENV DB_USER=mysql
ENV DB_PASSWORD=mysql

COPY mysql.sh /root/mysql.sh
ENTRYPOINT ["/root/mysql.sh"]