# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t kzlt_ruby .
# docker run -d -p 80:3000 -e RAILS_MASTER_KEY=<value from config/master.key> --name kzlt_ruby kzlt_ruby

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=4.0.10
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages (removed libvips from packages)
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y curl libjemalloc2 sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# litestream gem 0.16.1 bundles Litestream 0.5.17, which leaks connections (fixed in 0.5.18).
# Remove this and LITESTREAM_INSTALL_DIR once the gem bundles a fixed release.
# Cloud Build runs the legacy builder, which does not support ADD --checksum.
ARG LITESTREAM_VERSION=0.5.18
ARG LITESTREAM_SHA256=11d36a2d2058731ee99f201f6b68a52fcb1dd3050bdfd2237f7f39741dafe6ae
RUN curl -fsSL -o /tmp/litestream.deb \
      "https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM_VERSION}/litestream-${LITESTREAM_VERSION}-linux-x86_64.deb" && \
    echo "${LITESTREAM_SHA256}  /tmp/litestream.deb" | sha256sum -c - && \
    dpkg -i /tmp/litestream.deb && \
    rm /tmp/litestream.deb

# Set production environment
ENV LITESTREAM_INSTALL_DIR="/usr/bin" \
    RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/




# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/prd-entrypoint", "./bin/rails", "server"]
