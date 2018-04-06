FROM elixir:1.5.3-alpine

ENV COMMIT_HASH="303289d7daac3a51f991bb8603f36628a5d944c1"

RUN apk -U add gcc g++ \
            make git && \
        mkdir /opt/ && \
        cd /opt/ && \
        git clone https://git.pleroma.social/pleroma/pleroma && \
        cd /opt/pleroma/ && \
        git checkout $COMMIT_HASH . && \
        mix local.hex --force && \
        mix deps.get && \
        mix local.rebar --force && \
        mix deps.compile && \
        mix compile && \
        rm -rf ~/*
