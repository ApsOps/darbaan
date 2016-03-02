FROM ubuntu:trusty

MAINTAINER Amanpreet Singh

ENV OPENRESTY_VERSION 1.9.7.2
ENV BUILD_DEPS libreadline-dev libncurses5-dev libpcre3-dev \
               libssl-dev perl make build-essential curl

# Install OpenResty dependencies
RUN apt-get update
RUN apt-get -y install $BUILD_DEPS

# Install OpenResty with modules for Lua support
RUN curl -O http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz
RUN tar xzvf ngx_openresty-${OPENRESTY_VERSION}.tar.gz

WORKDIR /ngx_openresty-${OPENRESTY_VERSION}/
RUN ./configure --with-luajit \
                --with-http_gzip_static_module \
                --with-http_ssl_module \
                --with-pcre-jit
RUN make && \
    make install

RUN rm -rf /ngx_openresty*
RUN apt-get -y remove $BUILD_DEPS
RUN apt-get -y autoremove

VOLUME ["/opt/nginx"]

EXPOSE 80

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/opt/nginx/conf/nginx.conf"]
