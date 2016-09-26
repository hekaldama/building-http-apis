FROM ruby:2.3.1

COPY Gemfile /
RUN bundle

WORKDIR /src

CMD rerun "rackup -o 0.0.0.0 config.ru"
