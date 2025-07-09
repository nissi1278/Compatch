FROM ruby:3.4.3

# 必要なパッケージをインストール（Node.js, MySQLクライアント, その他依存）
RUN apt-get update && \
  apt-get install -y curl gnupg2 default-mysql-client && \
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y \
  nodejs \
  build-essential \
  git \
  bash \
  default-libmysqlclient-dev && \
  gem install bundler && \
  rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3