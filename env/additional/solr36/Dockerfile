FROM    java:openjdk-7-jre
MAINTAINER  Taras Shabatyn "tshabatyn@magento.com"

# Override the solr download location with e.g.:
#   docker build -t mine --build-arg SOLR_DOWNLOAD_SERVER=http://www-eu.apache.org/dist/lucene/solr .
ARG SOLR_DOWNLOAD_SERVER

# Override the GPG keyserver with e.g.:
#   docker build -t mine --build-arg GPG_KEYSERVER=hkp://eu.pool.sks-keyservers.net .
ARG GPG_KEYSERVER

RUN apt-get update && \
  apt-get -y install lsof && \
  rm -rf /var/lib/apt/lists/*

ENV SOLR_USER solr
ENV SOLR_UID 8983

RUN groupadd -r -g $SOLR_UID $SOLR_USER && \
  useradd -r -u $SOLR_UID -g $SOLR_USER $SOLR_USER

ARG SOLR_KEY
ENV GPG_KEYSERVER ${GPG_KEYSERVER:-hkp://ha.pool.sks-keyservers.net}
RUN gpg --keyserver "$GPG_KEYSERVER" --recv-keys "$SOLR_KEY"

ARG SOLR_VERSION
ARG SOLR_SOURCE_SHA256_HASH

ENV SOLR_URL ${SOLR_DOWNLOAD_SERVER:-https://archive.apache.org/dist/lucene/solr}/$SOLR_VERSION/apache-solr-$SOLR_VERSION.tgz

RUN mkdir -p /opt/solr && \
  wget -nv $SOLR_URL -O /opt/solr.tgz && \
  wget -nv $SOLR_URL.asc -O /opt/solr.tgz.asc && \
  echo "$SOLR_SOURCE_SHA256_HASH  /opt/solr.tgz" | sha1sum -c - && \
  (>&2 ls -l /opt/solr.tgz /opt/solr.tgz.asc) && \
  gpg --batch --verify /opt/solr.tgz.asc /opt/solr.tgz && \
  tar -C /opt/solr --extract --file /opt/solr.tgz --strip-components=1 && \
  rm /opt/solr.tgz* && \
  rm -Rf /opt/solr/docs/ && \
  mkdir /docker-entrypoint-initdb.d /opt/docker-solr/

COPY conf/* /opt/solr/example/solr/conf/

COPY scripts /opt/docker-solr/scripts
RUN chown -R $SOLR_USER:$SOLR_USER /opt/docker-solr /opt/solr

ENV PATH /opt/solr/bin:/opt/docker-solr/scripts:$PATH
ENV VERBOSE yes

EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_USER

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["java -jar /opt/solr/example/start.jar"]
#CMD ["server/solr"]
