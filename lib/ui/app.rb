require 'securerandom'
require 'sinatra'

require './lib/boot'

set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
enable :sessions

get '/version' do
  "Running BKE ##{BKE::VERSION} 🚀"
end

require_relative 'gate_keeper'
require_relative 'auth'
