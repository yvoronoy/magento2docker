# https://www.elastic.co/guide/en/elasticsearch/reference/5.6/docker.html
FROM elasticsearch:5.6
ADD config/elasticsearch.yml /usr/share/elasticsearch/config/
USER root
RUN chown elasticsearch:elasticsearch config/elasticsearch.yml
RUN bin/elasticsearch-plugin install x-pack
USER elasticsearch
