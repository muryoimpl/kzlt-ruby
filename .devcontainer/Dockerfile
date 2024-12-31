# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG VARIANT=ubuntu24.04
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

ENV LANG C.UTF-8

RUN apt-get update -y && \
    apt-get -y install --no-install-recommends \
    build-essential gnupg2 tar git zsh libssl-dev zlib1g-dev libyaml-dev libreadline-dev \
    apt-transport-https ca-certificates gnupg \
    libsqlite3-dev sqlite3 \
    curl less tzdata python3

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz \
  && tar -xf google-cloud-cli-linux-x86_64.tar.gz \
  && chown -R vscode /google-cloud-sdk \
  && su vscode -s /bin/zsh -c "/google-cloud-sdk/install.sh -q"

RUN usermod vscode -s /bin/zsh

ARG APP_PATH=/workspaces/kzlt-ruby
RUN mkdir -p $APP_PATH && chown vscode -R $APP_PATH

ARG RUBY_VERSION

USER vscode
RUN echo "if [ -f '/google-cloud-sdk/path.zsh.inc' ]; then . '/google-cloud-sdk/path.zsh.inc'; fi" >> ~/.zshrc \
  && echo "if [ -f '/google-cloud-sdk/completion.zsh.inc' ]; then . '/google-cloud-sdk/completion.zsh.inc'; fi" >> ~/.zshrc

RUN git clone https://github.com/rbenv/rbenv.git /home/vscode/.rbenv  \
    && echo '[ -f "/home/vscode/.rbenv/bin/rbenv" ] && eval "$(rbenv init - zsh)" ' >> /home/vscode/.zshrc \
    && echo '[ -f "/home/vscode/.rbenv/bin/rbenv" ] && eval "$(rbenv init - bash)" ' >> /home/vscode/.bashrc \
    && echo 'export PATH="/home/vscode/.rbenv/bin:$PATH"' >> /home/vscode/.zshrc \
    && echo 'export PATH="/home/vscode/.rbenv/bin:$PATH"' >> /home/vscode/.bashrc \
    && mkdir -p /home/vscode/.rbenv/versions \
    && mkdir -p /home/vscode/.rbenv/plugins \
    && git clone https://github.com/rbenv/ruby-build.git /home/vscode/.rbenv/plugins/ruby-build

ENV PATH="/home/vscode/.rbenv/bin/:HOME/.rbenv/shims/:$PATH"

WORKDIR $APP_PATH
COPY Gemfile .

RUN rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION
RUN $HOME/.rbenv/shims/bundle config set path 'vendor/bundle' && $HOME/.rbenv/shims/bundle

COPY . .
