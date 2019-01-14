FROM sirboops/elixir:1.7.4-alpine as elixir
FROM alpine:3.8

ENV COMMIT_HASH="f5d7b0003ea200d13abca2cbd4e4f59db9658231"

# Install OTP
COPY --from=elixir /opt/otp /opt/otp
RUN apk add ncurses-libs zlib
ENV PATH="$PATH:/opt/otp/bin"

# Install Elixir
COPY --from=elixir /opt/elixir /opt/elixir
ENV PATH="$PATH:/opt/elixir/usr/local/bin"

# Build Pleroma
RUN apk add git build-base && \
	cd /opt && \
	git clone https://git.pleroma.social/pleroma/pleroma.git/ && \
	cd pleroma && \
	git checkout $COMMIT_HASH && \
	mix local.hex --force && \
	mix deps.get && \
	mix local.rebar --force && \
	mix deps.compile && \
	mix compile

# Pleroma Run args
WORKDIR /opt/pleroma
CMD mix ecto.migrate && mix phx.server
