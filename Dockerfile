FROM alpine:3.7

ENV ERLANG_VERSION "20.2"
ENV ELIXIR_VERSION "1.6.0"
ENV NODEJS_VERSION "8.9.3"
ENV PHX_VERSION "1.3.0"

RUN apk add --update --no-cache autoconf automake bash curl alpine-sdk perl openssl openssl-dev ncurses ncurses-dev unixodbc unixodbc-dev git ca-certificates nodejs postgresql-client

RUN apk add --virtual .asdf-deps --no-cache bash curl git
SHELL ["/bin/bash", "-l", "-c"]
RUN adduser -s /bin/bash -h /asdf -D asdf
ENV PATH="${PATH}:/asdf/.asdf/shims:/asdf/.asdf/bin"

USER asdf
WORKDIR /asdf

COPY asdf-install-toolset /usr/local/bin

USER asdf
RUN git clone --depth 1 https://github.com/asdf-vm/asdf.git $HOME/.asdf && \
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc && \
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.profile && \
    source ~/.bashrc && \
    mkdir -p $HOME/.asdf/toolset

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
