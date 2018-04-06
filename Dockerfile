FROM elixir:1.5.3-alpine

ENV PL_VER="0.9.0"

RUN addgroup pleroma && \
        adduser -H -D -G pleroma pleroma && \
        echo "pleroma:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk -U add --virtual deps \
            gcc g++ make && \
        apk add git && \
        cd ~ && \
        wget https://git.pleroma.social/pleroma/pleroma/repository/v$PL_VER/archive.tar.gz && \
        tar xf archive.tar.gz && \
        mkdir /opt/ && \
        mv ~/pleroma-*/ /opt/pleroma/ && \
        cd /opt/pleroma && \
        mix local.hex --force && \
        mix deps.get && \
        mix local.rebar --force && \
        mix deps.compile && \
        mix compile && \
        rm -rf ~/* && \
        apk del --purge deps && \
        chown 1000:1000 -R /opt/pleroma/*
