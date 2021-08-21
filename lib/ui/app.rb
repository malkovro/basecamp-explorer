require 'securerandom'
require 'sinatra'
require 'sinatra/reloader' if development?

require './lib/boot'

require_relative 'gate_keeper'

GATE_KEEPER = GateKeeper.new

set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
enable :sessions

get '/version' do
  "Running BKE ##{BKE::VERSION} 🚀"
end

require_relative 'auth'

get '/' do
  negotiator = GATE_KEEPER.current(session)

  accounts = negotiator.bc3_accounts if negotiator&.connected?
  erb :index, locals: { accounts: accounts || [] }
end

get '/bc3-account/:account_id/projects' do
  negotiator = GATE_KEEPER.current(session)
  redirect '/login' unless negotiator&.connected?

  account = negotiator.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }

  erb :project_list, locals: { account: account }
end

get '/bc3-account/:account_id/projects/:project_id' do
  negotiator = GATE_KEEPER.current(session)
  redirect '/login' unless negotiator&.connected?

  account = negotiator.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }
  project = account.projects.detect { |p| p.id.to_s == params['project_id'] }

  erb :project_show, locals: { project: project, account: account }
end
