FROM debian:trixie-slim AS builder

RUN apt-get update \
    && apt-get install --yes --no-install-recommends build-essential cmake curl ca-certificates libncurses-dev libssl-dev pkg-config libtirpc-dev \
    && curl --location --remote-name https://dev.mysql.com/get/Downloads/MySQL-8.4/mysql-8.4.13.1.tar.gz \
    && tar -xzf mysql-8.4.13.1.tar.gz \
    && mkdir /build \
    && cd /build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DWITHOUT_SERVER=1 -DWITH_LTO=1 -DWITH_UNIT_TESTS=0 ../mysql-8.4.13.1 \
    && make install

FROM gcr.io/distroless/cc-debian13:nonroot AS final

COPY --from=builder /usr/local/mysql/bin/mysql /
COPY --from=builder /lib/x86_64-linux-gnu/libtinfo.so.6.5 /mysql-libs/libtinfo.so.6

ENV LD_LIBRARY_PATH=/mysql-libs

ENTRYPOINT ["/mysql", "--protocol=tcp"]
CMD ["--help"]
