ARG M2D_ENABLE_BLACKFIRE='no'

FROM scratch as m2d_blackfire_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM blackfire/blackfire AS m2d_blackfire_yes

FROM m2d_blackfire_${M2D_ENABLE_BLACKFIRE} AS m2d_blackfire
