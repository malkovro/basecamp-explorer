FROM ruby:2.7.4

COPY Gemfile Gemfile.lock ./

RUN bundle install

CMD [ "irb", "-r", "./lib/cli.rb" ]
