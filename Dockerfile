FROM vborja/asdf-alpine:latest

ENV ERLANG_VERSION "20.2.4"
ENV ELIXIR_VERSION "1.6.3"
ENV PHX_VERSION "1.3.2"

USER root
RUN apk add --update --no-cache autoconf automake bash curl alpine-sdk perl imagemagick openssl openssl-dev ncurses ncurses-dev unixodbc unixodbc-dev git ca-certificates nodejs postgresql-client

USER asdf
RUN asdf update --head

RUN asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && \
    asdf install erlang $ERLANG_VERSION && \
    asdf global erlang $ERLANG_VERSION

RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
    asdf install elixir $ELIXIR_VERSION && \
    asdf global elixir $ELIXIR_VERSION

RUN yes | mix local.hex --force && \
    yes | mix local.rebar --force

RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new-$PHX_VERSION.ez --force

CMD ["/bin/bash"]
