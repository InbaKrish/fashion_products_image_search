FROM ruby:3.2.2

WORKDIR /fashion_products_vdb

ENV BUNDLER_VERSION=2.4.12
RUN apt-get update && apt-get install -y curl yarn nodejs postgresql-client
RUN gem install bundler --version "$BUNDLER_VERSION"
EXPOSE 3000