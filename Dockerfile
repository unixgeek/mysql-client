FROM debian:bookworm-20251117-slim AS builder

RUN apt-get update \
    && apt-get install --yes --no-install-recommends bison build-essential cmake curl ca-certificates libncurses-dev libssl-dev libudev-dev pkg-config \
    && curl --location --remote-name https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-8.0.44.tar.gz  \
    && tar -xzf mysql-boost-8.0.44.tar.gz \
    && curl --remote-name https://archives.boost.io/release/1.77.0/source/boost_1_77_0.tar.bz2 \
    && tar -xjf boost_1_77_0.tar.bz2 \
    && cd boost_1_77_0 \
    && ./bootstrap.sh \
    && ./b2 \
    && ./b2 install \
    && mkdir /build \
    && cd /build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DWITHOUT_SERVER=1 -DWITH_LTO=1 -DWITH_UNIT_TESTS=0  ../mysql-8.0.44 \
    && make install

FROM gcr.io/distroless/cc-debian12:nonroot AS final

COPY --from=builder /usr/local/mysql/bin/mysql /
COPY --from=builder /lib/x86_64-linux-gnu/libtinfo.so.6.4 /mysql-libs/libtinfo.so.6

ENV LD_LIBRARY_PATH=/mysql-libs
ENV MYSQL_HOST=localhost
ENV MYSQL_TCP_PORT=3306
ENV USER=mysql
ENV MYSQL_PWD=root

ENTRYPOINT ["/mysql", "--protocol=tcp"]
CMD ["--help"]
