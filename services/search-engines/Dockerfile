ARG M2D_ENABLE_SEARCH_ENGINE='yes'
ARG M2D_SEARCH_ENGINE_VENDOR='elasticsearch'
ARG M2D_SEARCH_ENGINE_VERSION='7'

FROM scratch as m2d_search_engine_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM m2d_search_engine_no AS m2d_search_engine_no_opensearch
FROM m2d_search_engine_no AS m2d_search_engine_no_elasticsearch

FROM opensearchproject/opensearch:1.2.4 AS m2d_search_engine_yes_opensearch_1
FROM opensearchproject/opensearch:2.5.0 AS m2d_search_engine_yes_opensearch_2

FROM opensearchproject/opensearch:1.2.4 AS m2d_search_engine_yes_opensearch_1.2
FROM opensearchproject/opensearch:2.5.0 AS m2d_search_engine_yes_opensearch_2.5

FROM m2d_search_engine_yes_opensearch_${M2D_SEARCH_ENGINE_VERSION} AS m2d_search_engine_yes_opensearch
ENV DISABLE_INSTALL_DEMO_CONFIG=true \
    discovery.type=single-node \
    plugins.security.disabled=true \
    http.host=0.0.0.0 \
    http.port=9200

FROM --platform=linux/amd64 elasticsearch:6.8.23 AS m2d_search_engine_yes_elasticsearch_6
FROM elasticsearch:7.16.3 AS m2d_search_engine_yes_elasticsearch_7
FROM elasticsearch:8.4.3 AS m2d_search_engine_yes_elasticsearch_8

FROM --platform=linux/amd64 elasticsearch:7.6.2 AS m2d_search_engine_yes_elasticsearch_7.6
FROM --platform=linux/amd64 elasticsearch:7.7.1 AS m2d_search_engine_yes_elasticsearch_7.7
FROM elasticsearch:7.9.3 AS m2d_search_engine_yes_elasticsearch_7.9
FROM elasticsearch:7.10.1 AS m2d_search_engine_yes_elasticsearch_7.10
FROM elasticsearch:7.16.3 AS m2d_search_engine_yes_elasticsearch_7.16
FROM elasticsearch:7.17.9 AS m2d_search_engine_yes_elasticsearch_7.17
FROM elasticsearch:8.4.3 AS m2d_search_engine_yes_elasticsearch_8.4

FROM m2d_search_engine_yes_elasticsearch_${M2D_SEARCH_ENGINE_VERSION} AS m2d_search_engine_yes_elasticsearch
COPY --chown=elasticsearch:elasticsearch services/search-engines/etc/elasticsearch.yml /usr/share/elasticsearch/config/

FROM m2d_search_engine_${M2D_ENABLE_SEARCH_ENGINE}_${M2D_SEARCH_ENGINE_VENDOR} AS m2d_search_engine
