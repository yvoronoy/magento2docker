ARG M2D_ENABLE_DB_CACHE='no'
ARG M2D_DB_CACHE_VENDOR='redis'
ARG M2D_DB_CACHE_VERSION='6.0'

FROM scratch as m2d_db_cache_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM redis:5.0-bullseye AS m2d_db_cache_yes_redis_5
FROM redis:6.0-bullseye AS m2d_db_cache_yes_redis_6
FROM redis:6.2-bullseye AS m2d_db_cache_yes_redis_6.2
FROM redis:7.0-bullseye AS m2d_db_cache_yes_redis_7

FROM m2d_db_cache_yes_${M2D_DB_CACHE_VENDOR}_${M2D_DB_CACHE_VERSION} AS m2d_db_cache_yes

FROM m2d_db_cache_${M2D_ENABLE_DB_CACHE} AS m2d_db_cache
