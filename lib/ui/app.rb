require 'securerandom'
require 'sinatra'
require 'sinatra/reloader' if development?

require './lib/boot'

require 'connection_center'
require_relative 'gate_keeper'

GATE_KEEPER = GateKeeper.new

set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
enable :sessions

get '/version' do
  "Running BKE ##{BKE::VERSION} 🚀"
end

require_relative 'auth'

get '/' do
  connection_center = GATE_KEEPER.current(session)
  basecamp_negotiator = connection_center&.basecamp
  gh_negotiator = connection_center&.github
  accounts = basecamp_negotiator.bc3_accounts if basecamp_negotiator&.connected?
  gh_connected = gh_negotiator&.connected?
  erb :index, locals: { accounts: accounts || [], gh_connected: gh_connected }
end

get '/bc3-account/:account_id/projects' do
  negotiator = GATE_KEEPER.current(session)
  basecamp_negotiator = negotiator.basecamp

  redirect '/basecamp/login' unless basecamp_negotiator&.connected?

  account = basecamp_negotiator.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }

  erb :project_list, locals: { account: account }
end

get '/bc3-account/:account_id/projects/:project_id' do
  negotiator = GATE_KEEPER.current(session)
  basecamp_negotiator = negotiator&.basecamp
  gh_negotiator = negotiator&.github

  redirect '/basecamp/login' unless basecamp_negotiator&.connected?
  redirect '/github/login' unless gh_negotiator&.connected?

  account = basecamp_negotiator.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }
  project = account.projects.detect { |p| p.id.to_s == params['project_id'] }

  todolists = project.todoset.todolists

  erb :project_show, locals: { project: project, account: account, todolists: todolists }
end

get '/bc3-account/:account_id/projects/:project_id/todolist/:todolist' do
  negotiator = GATE_KEEPER.current(session)
  basecamp_negotiator = negotiator&.basecamp
  gh_negotiator = negotiator&.github

  redirect '/basecamp/login' unless basecamp_negotiator&.connected?
  redirect '/github/login' unless gh_negotiator&.connected?

  gh_client = gh_negotiator.authenticated_client
  account = basecamp_negotiator.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }
  project = account.projects.detect { |p| p.id.to_s == params['project_id'] }
  todolist = project.todoset.todolists.detect { |tl| tl.id.to_s == params['todolist'] }
  bkb_todos = todolist.completed_todos.map { |todo| Barkibu::Todo.new(todo, gh_client) }
  reportable_todos = bkb_todos.select(&:reportable?)

  erb :todolist_show,
      locals: { project: project, account: account, todolist: todolist, reportable_todos: reportable_todos }
end
