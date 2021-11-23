FROM openresty/openresty:bullseye-fat

# Create nginx user/group
RUN set -x \
    && addgroup --system --gid 1000 nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 1000 nginx \
    && DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade \
    &&  rm -rf /var/lib/apt/lists/*

