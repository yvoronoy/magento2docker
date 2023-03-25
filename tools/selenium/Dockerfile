ARG M2D_ENABLE_SELENIUM='no'
ARG M2D_SELENIUM_VERSION='3.14.0'
ARG M2D_CPU_TYPE='m1'

FROM scratch as m2d_selenium_no
COPY tools/dummy/dummy ./
CMD ["/dummy"]

FROM m2d_selenium_no AS m2d_selenium_no_m1
FROM m2d_selenium_no AS m2d_selenium_no_intel

FROM selenium/standalone-chrome-debug:${M2D_SELENIUM_VERSION} AS m2d_selenium_yes_intel

# there are no official versions compiled for Apple M1;
# there is https://hub.docker.com/u/seleniarm but they not offer standalone-chrome-debug
# the below will pick an image for the amd64 platform, and it will be executed in emulation mode so that it will be SLOW!
FROM --platform=linux/amd64 selenium/standalone-chrome-debug:${M2D_SELENIUM_VERSION} AS m2d_selenium_yes_m1

FROM m2d_selenium_${M2D_ENABLE_SELENIUM}_${M2D_CPU_TYPE} AS m2d_selenium
