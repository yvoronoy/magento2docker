ARG M2D_ENABLE_WEB_CACHE='no'
ARG M2D_WEB_CACHE_VENDOR='varnish'
ARG M2D_WEB_CACHE_VERSION='6.5'

FROM scratch as m2d_web_cache_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM ${M2D_WEB_CACHE_VENDOR}:${M2D_WEB_CACHE_VERSION} AS m2d_web_cache_yes

FROM m2d_web_cache_${M2D_ENABLE_WEB_CACHE} AS m2d_web_cache
