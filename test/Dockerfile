FROM debian

RUN dpkg --add-architecture i386 && apt-get -q update
RUN apt-get -q install -y --no-install-recommends \
  make \
  bash \
  libc-dev:i386 \
  gcc:i386
