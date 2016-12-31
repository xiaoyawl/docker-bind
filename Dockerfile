FROM benyoo/alpine:3.4.20160812

MAINTAINER from www.dwhd.org by lookback (mondeolove@gmail.com)

ARG BIND_VERSION=${BIND_VERSION:-9.11.0}
ENV TEMP_DIR=/tmp/bind \
	INSTALL_DIR=/usr/local/named \
	PATH=/usr/local/named/bin:/usr/local/named/sbin:$PATH

RUN set -x && \
	apk --update --no-cache upgrade && \
	apk --update --no-cache add tar curl openssl-dev gcc g++ make linux-headers perl-dev && \
	mkdir -p ${TEMP_DIR} && cd ${TEMP_DIR} && \
	addgroup -g 410 -S named && \
	adduser -u 410 -S -H -s /sbin/nologin -g 'DNS Server' -G named named && \
	curl -Lk "ftp://ftp.isc.org/isc/bind9/${BIND_VERSION}/bind-${BIND_VERSION}.tar.gz" | tar -xz -C ${TEMP_DIR} --strip-components=1 && \
	CFLAGS="-static" ./configure --with-openssl --enable-full-report --disable-linux-caps --prefix=${INSTALL_DIR} && \
	make -j$(getconf _NPROCESSORS_ONLN) && \
	make install && cd ../ && \
	apk del gcc g++ make perl-dev perl tar && \
	rm -rf ${TEMP_DIR}

COPY etc /usr/local/named/etc
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["named"]
