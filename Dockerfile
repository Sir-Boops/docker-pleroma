FROM elixir:1.5.3-alpine

ENV COMMIT_HASH="fef8daa454ab04ac2394e02efcc2b48c1fbad91c"
ENV MIX_ENV=prod

RUN addgroup pleroma && \
        adduser -D -h /opt -G pleroma pleroma && \
        echo "pleroma:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk -U add gcc g++ \
            make git && \
        su - -s /bin/ash pleroma -c \
            "git clone https://git.pleroma.social/pleroma/pleroma && \
            cd /opt/pleroma/ && \
            git checkout $COMMIT_HASH . && \
            mix local.hex --force && \
            mix deps.get && \
            mix local.rebar --force && \
            mix deps.compile && \
            mix compile"

COPY start.sh /opt/pleroma/

CMD /bin/ash /opt/pleroma/start.sh
