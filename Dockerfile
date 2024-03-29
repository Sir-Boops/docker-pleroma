FROM sirboops/elixir:1.7.4-alpine as elixir
FROM alpine:3.8

# Set pleroma version
ENV PLE_TAG="0.9.9999"

# Create system user and update
RUN addgroup pleroma && \
	mkdir -p /opt/pleroma && \
	adduser -u 1000 -S -D -h /opt/pleroma -G pleroma pleroma && \
	apk upgrade

# Install OTP
COPY --from=elixir /opt/otp /opt/otp
RUN apk add ncurses-libs zlib
ENV PATH="$PATH:/opt/otp/bin"

# Install Elixir
COPY --from=elixir /opt/elixir /opt/elixir
ENV PATH="$PATH:/opt/elixir/usr/local/bin"

# Build Pleroma
RUN apk add git build-base

USER pleroma

RUN	cd ~ && \
	git clone https://git.pleroma.social/pleroma/pleroma.git/ . && \
	git checkout tags/v$PLE_TAG && \
	mix local.hex --force && \
	mix deps.get && \
	mix local.rebar --force && \
	mix deps.compile && \
	mix compile

# Pleroma Run args
WORKDIR /opt/pleroma
CMD mix ecto.migrate && mix phx.server
