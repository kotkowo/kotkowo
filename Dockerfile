ARG ELIXIR_VERSION=1.15.5
ARG OTP_VERSION=26.0.2
ARG DEBIAN_VERSION=bullseye-20230612-slim

ARG BUILDER_IMAGE="hexpm/elixir-${BUILDARCH}:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="arm64v8/debian:${DEBIAN_VERSION}"

FROM --platform=$BUILDPLATFORM arm64v8/rust:1.72 as rust_nightly

FROM --platform=$BUILDPLATFORM arm64v8/node:20.6-buster-slim as build-node

ADD assets /app/assets
WORKDIR /app/assets
RUN npm install

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN dpkg --add-architecture arm64 && apt-get update -y && apt-get install -y build-essential git libssl-dev pkg-config musl libc6 libc6:arm64 \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy rust deps
COPY --from=rust_nightly /usr/local/cargo /usr/local/cargo
COPY --from=rust_nightly /usr/local/rustup /usr/local/rustup

ENV PATH="/usr/local/cargo/bin:${PATH}"

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv

COPY lib lib

COPY native native

COPY --from=build-node /app/assets ./assets

# compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM --platform=$BUILDPLATFORM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/kotkowo ./

USER nobody

CMD ["/app/bin/server"]
