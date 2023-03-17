ARG M2D_ENABLE_DB_CACHE='no'
ARG M2D_DB_CACHE_VENDOR='redis'
ARG M2D_DB_CACHE_VERSION='6.0'

FROM scratch as m2d_db_cache_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM ${M2D_DB_CACHE_VENDOR}:${M2D_DB_CACHE_VERSION} AS m2d_db_cache_yes

FROM m2d_db_cache_${M2D_ENABLE_DB_CACHE} AS m2d_db_cache
