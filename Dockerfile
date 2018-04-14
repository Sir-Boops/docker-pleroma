FROM elixir:1.5.3-alpine

ENV COMMIT_HASH="fef8daa454ab04ac2394e02efcc2b48c1fbad91c"

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

COPY start.sh /opt/pleroma/

ENTRYPOINT /bin/ash /opt/pleroma/start.sh
