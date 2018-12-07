FROM alpine:3.8

ENV COMMIT_HASH="7d86c0c53f6377119581ddc9e9dfe5c0937ffe01"

RUN addgroup pleroma && \
        adduser -D -h /opt -G pleroma pleroma && \
        echo "pleroma:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk -U add gcc g++ \
        make git elixir \
				erlang-runtime-tools \
				erlang-xmerl

USER pleroma
RUN cd ~ && \
    git clone https://git.pleroma.social/pleroma/pleroma.git/ && \
    cd /opt/pleroma/ && \
    git checkout $COMMIT_HASH . && \
    mix local.hex --force && \
    mix deps.get && \
    mix local.rebar --force && \
    mix deps.compile && \
    mix compile

WORKDIR /opt/pleroma
CMD mix ecto.migrate && mix phx.server
