web: bundle exec rackup config.ru -p ${PORT:-5000}
worker: bundle exec sidekiq -c 5 -r ./lib/boot.rb
