FROM sirboops/elixir:1.7.4-alpine as elixir
FROM alpine:3.8

# Set pleroma hash
ENV COMMIT_HASH="bd89cdbe318ce12e0273163a51f2907e6e763be6"

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
	git checkout $COMMIT_HASH && \
	mix local.hex --force && \
	mix deps.get && \
	mix local.rebar --force && \
	mix deps.compile && \
	mix compile

# Pleroma Run args
WORKDIR /opt/pleroma
CMD mix ecto.migrate && mix phx.server
