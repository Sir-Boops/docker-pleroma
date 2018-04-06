FROM elixir:1.5.3-alpine

ENV COMMIT_HASH="86058c9a8883c5f6c71f1d3553ca52f658fdf79e"

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
        mix compile
