FROM openresty/openresty:bullseye-fat

# Create nginx user/group
RUN set -x \
    && addgroup --system --gid 1000 nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 1000 nginx \
    && usermod -a -G tty nginx \
    && chmod o+w /dev/stderr \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install procps \
    && rm -rf /var/lib/apt/lists/* \
    && chown -R nginx:nginx /usr/local/openresty/nginx

USER nginx
