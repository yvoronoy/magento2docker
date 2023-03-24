ARG M2D_ENABLE_WEB_CACHE='no'
ARG M2D_WEB_CACHE_VENDOR='varnish'
ARG M2D_WEB_CACHE_VERSION='6.5'

FROM scratch as m2d_web_cache_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM varnish:6.0 AS m2d_web_cache_yes_varnish_6.0
FROM --platform=linux/amd64 varnish:6.2 AS m2d_web_cache_yes_varnish_6.2
FROM --platform=linux/amd64 varnish:6.4 AS m2d_web_cache_yes_varnish_6.4
FROM --platform=linux/amd64 varnish:6.5 AS m2d_web_cache_yes_varnish_6.5
FROM varnish:7.0 AS m2d_web_cache_yes_varnish_7.0
FROM varnish:7.1 AS m2d_web_cache_yes_varnish_7.1

FROM m2d_web_cache_yes_varnish_7.0 AS m2d_web_cache_yes_varnish_7
FROM m2d_web_cache_yes_varnish_6.5 AS m2d_web_cache_yes_varnish_6

FROM m2d_web_cache_yes_${M2D_WEB_CACHE_VENDOR}_${M2D_WEB_CACHE_VERSION} AS m2d_web_cache_yes

FROM m2d_web_cache_${M2D_ENABLE_WEB_CACHE} AS m2d_web_cache
