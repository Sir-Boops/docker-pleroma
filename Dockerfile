FROM elixir:1.5.3-alpine

ENV PL_VER="0.9.0"

RUN apk -U add gcc g++ \
            make git && \
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
        rm -rf ~/*
