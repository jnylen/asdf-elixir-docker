FROM vborja/asdf-alpine:latest

ENV ERLANG_VERSION "20.2.4"
ENV ELIXIR_VERSION "1.6.3"
ENV PHX_VERSION "1.3.2"
ENV TIMEZONE "Europe/Moscow"

USER root
RUN apk add --update --no-cache autoconf automake bash curl alpine-sdk perl imagemagick openssl openssl-dev ncurses ncurses-dev unixodbc unixodbc-dev git ca-certificates postgresql-client tzdata coreutils
RUN cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime

USER asdf
RUN asdf update --head

# Adding Erlang, Elixir and NodeJS plugins
RUN asdf plugin-add erlang && \
    asdf plugin-add elixir && \
    asdf plugin-add nodejs

# Adding Erlang installation and dependencies requirements
USER root
RUN apk add openssh-client gawk grep yaml-dev expat-dev libxml2-dev
USER asdf

# Adding Erlang/OTP 20.2.4
RUN asdf install erlang 20.2.4

# Adding Elixir 1.6 with corresponding Erlang
RUN asdf install elixir 1.6.3 && \
    asdf global erlang 20.2.4 && \
    asdf global elixir 1.6.3 && \
    yes | mix local.hex --force && \
    yes | mix local.rebar --force


# NodeJS requirements
USER root
RUN apk add curl make gcc g++ python linux-headers binutils-gold gnupg perl-utils libstdc++
RUN apk add --update rsync    
USER asdf
RUN gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 94AE36675C464D64BAFA68DD7434390BDBE9B9C5 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys FD3A5288F042B6850C66B31F09FE44734EB7990E && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys B9AE9905FFD7803F25714661B63B535A4C206CA9 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 56730D5401028683275BD23C23EFEFE93C4CFFFE && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 77984A986EBC2AA786BC0F66B01FBB92821C587A

# Adding NodeJS 8.10.0 LTS
RUN asdf install nodejs 8.10.0

# Setting global versions
RUN asdf global erlang 20.2.4 && \
    asdf global elixir 1.6.3  && \
    asdf global nodejs 8.10.0

    
CMD ["/bin/bash"]
