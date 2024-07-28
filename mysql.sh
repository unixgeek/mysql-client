#!/bin/sh -e

exec mysql --user="${DB_USER}"         \
           --password="${DB_PASSWORD}" \
           --host="${DB_HOST}"         \
           --port="${DB_PORT}"         \
           --protocol=tcp              \
           "${DB_NAME}" "$@"