FROM elixir:1.5.3-alpine

ENV COMMIT_HASH="41b0ecef959df0a1cda71e56e256cacebe48d56f"

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

CMD cd ~/pleroma && mix ecto.migrate && mix phx.server
