ARG M2D_ENABLE_MESSAGE_BROKER='no'
ARG M2D_MESSAGE_BROKER_VENDOR='rabbitmq'
ARG M2D_MESSAGE_BROKER_VERSION='3.8-management'

FROM scratch as m2d_message_broker_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM ${M2D_MESSAGE_BROKER_VENDOR}:${M2D_MESSAGE_BROKER_VERSION} AS m2d_message_broker_yes

FROM m2d_message_broker_${M2D_ENABLE_MESSAGE_BROKER} AS m2d_message_broker
