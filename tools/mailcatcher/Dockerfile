## set the default value for the argument if not defined
ARG M2D_ENABLE_MAILCATCHER='no'

## prepare a dummy container for the "no" option
FROM scratch as m2d_mailcatcher_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

## prepare the actual Mailcatcher container for the "yes" option
FROM schickling/mailcatcher AS m2d_mailcatcher_yes

## build target container from mailcatcher_yes or mailcatcher_no based on value from M2D_ENABLE_MAILCATCHER argument
FROM m2d_mailcatcher_${M2D_ENABLE_MAILCATCHER} AS m2d_mailcatcher
