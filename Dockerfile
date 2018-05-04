FROM elixir:1.5.3-alpine

ENV COMMIT_HASH="5b6d6d7f2d9363c494642bfda4d6e4d12daa53c7"

RUN addgroup pleroma && \
        adduser -D -h /opt -G pleroma pleroma && \
        echo "pleroma:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk -U add gcc g++ \
        make git

USER pleroma
RUN cd ~ && \
    git clone https://git.pleroma.social/pleroma/pleroma && \
    cd /opt/pleroma/ && \
    git checkout $COMMIT_HASH . && \
    mix local.hex --force && \
    mix deps.get && \
    mix local.rebar --force && \
    mix deps.compile && \
    mix compile

EXPOSE 4000
CMD cd ~/pleroma && mix ecto.migrate && mix phx.server
