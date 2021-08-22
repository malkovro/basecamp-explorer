require 'securerandom'
require 'sinatra'
require 'sinatra/reloader' if development?

require './lib/boot'

require_relative 'connection_center'
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

get '/bc3-account/:account_id/projects/:project_id/todolist/:todolist_id' do
  job_id = SecureRandom.uuid
  negotiator = GATE_KEEPER.current(session)
  basecamp_negotiator = negotiator&.basecamp
  gh_negotiator = negotiator&.github

  redirect '/basecamp/login' unless basecamp_negotiator&.connected?
  redirect '/github/login' unless gh_negotiator&.connected?

  StoreReportableWorker.perform_async(
    gh_access_token: gh_negotiator.access_token.token,
    basecamp_access_token: basecamp_negotiator.access_token.token,
    account_id: params['account_id'].to_i,
    project_id: params['project_id'].to_i,
    todolist_id: params['todolist_id'].to_i,
    id: job_id
  )

  redirect "#{request.url}/job/#{job_id}"
end

get '/bc3-account/:account_id/projects/:project_id/todolist/:todolist_id/job/:job_id' do
  job_result = JobRepository.fetch(params[:job_id])
  negotiator = GATE_KEEPER.current(session)
  basecamp_negotiator = negotiator&.basecamp
  gh_negotiator = negotiator&.github

  redirect '/basecamp/login' unless basecamp_negotiator&.connected?
  redirect '/github/login' unless gh_negotiator&.connected?

  reportable_todos = (job_result.todos if job_result.is_a? ReportableTodos)
  job_failed = job_result.is_a? JobRepository::FailedJob

  account = basecamp_negotiator.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }
  project = account.projects.detect { |p| p.id.to_s == params['project_id'] }
  todolist = project.todoset.todolists.detect { |tl| tl.id.to_s == params['todolist_id'] }

  erb :todolist_show,
      locals: { project: project, account: account, todolist: todolist, reportable_todos: reportable_todos, job_failed: job_failed }
end
