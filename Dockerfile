FROM ruby:2.7.4

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY Gemfile Gemfile.lock ./

RUN bundle install

ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "irb", "-r", "./lib/cli.rb" ]
