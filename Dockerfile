FROM alpine:3.8

ENV ERL_VER="f0ea49125815ec9197ffb6c74e20ebb5f10732d4"
ENV ELX_VER="eb5679bfcc9bd35c4c016e91745b4a1a4d43356a"
ENV COMMIT_HASH="f5d7b0003ea200d13abca2cbd4e4f59db9658231"

# Build OTP
RUN apk add --virtual deps \
		git build-base autoconf ncurses-dev zlib-dev libressl-dev && \
	apk add ncurses-libs zlib && \
	cd ~ && \
	git clone https://github.com/erlang/otp && \
	cd otp && \
	git checkout $ERL_VER && \
	./otp_build autoconf && \
	./configure --prefix=/opt/otp && \
	make -j$(nproc) && \
	make install && \
	cd ~ && \
	rm -rf otp

# Add OTP to path
ENV PATH="$PATH:/opt/otp/bin"

# Build elixir
RUN cd ~ && \
	git clone https://github.com/elixir-lang/elixir && \
	cd elixir && \
	git checkout $ELX_VER && \
	make -j$(nproc) && \
	make DESTDIR="/opt/elixir" install && \
	cd ~ && \
	rm -rf elixir

# Add elixir to path
ENV PATH="$PATH:/opt/elixir/usr/local/bin/"

# Build Pleroma
RUN apk del --purge deps && \
	apk add git build-base && \
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
