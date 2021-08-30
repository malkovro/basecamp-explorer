require 'securerandom'
require 'sinatra'
require 'sinatra/reloader' if development?

require './lib/boot'

require_relative 'session_helper'

set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
enable :sessions

get '/version' do
  "Running BKE ##{BKE::VERSION} 🚀"
end

require_relative 'auth'

get '/' do
  session_helper = SessionHelper.new(session)
  basecamp_oauth = session_helper.basecamp_oauth
  gh_oauth = session_helper.gh_oauth
  accounts = basecamp_oauth.bc3_accounts if basecamp_oauth.connected?
  gh_connected = gh_oauth.connected?

  erb :index, locals: { accounts: accounts || [], gh_connected: gh_connected }
end

get '/bc3-account/:account_id/projects' do
  session_helper = SessionHelper.new(session)
  basecamp_oauth = session_helper.basecamp_oauth

  redirect '/basecamp/login' unless basecamp_oauth.connected?

  account = basecamp_oauth.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }

  erb :project_list, locals: { account: account }
end

get '/bc3-account/:account_id/projects/:project_id' do
  session_helper = SessionHelper.new(session)
  basecamp_oauth = session_helper.basecamp_oauth
  gh_oauth = session_helper.gh_oauth

  redirect '/basecamp/login' unless basecamp_oauth.connected?
  redirect '/github/login' unless gh_oauth.connected?

  account = basecamp_oauth.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }
  project = account.projects.detect { |p| p.id.to_s == params['project_id'] }

  todolists = project.todoset.todolists
  archived_todolists = project.todoset.archived_todolists

  erb :project_show,
      locals: { project: project, account: account, todolists: todolists, archived_todolists: archived_todolists }
end

get '/bc3-account/:account_id/projects/:project_id/todolist/:todolist_id' do
  job_id = SecureRandom.uuid
  session_helper = SessionHelper.new(session)
  basecamp_oauth = session_helper.basecamp_oauth
  gh_oauth = session_helper.gh_oauth

  redirect '/basecamp/login' unless basecamp_oauth.connected?
  redirect '/github/login' unless gh_oauth.connected?

  StoreReportableWorker.perform_async(
    gh_access_token: gh_oauth.access_token.token,
    basecamp_access_token: basecamp_oauth.access_token.token,
    account_id: params['account_id'].to_i,
    project_id: params['project_id'].to_i,
    todolist_id: params['todolist_id'].to_i,
    id: job_id
  )

  redirect "#{request.url}/job/#{job_id}"
end

get '/bc3-account/:account_id/projects/:project_id/todolist/:todolist_id/job/:job_id' do
  job_result = JobRepository.fetch(params[:job_id])
  session_helper = SessionHelper.new(session)
  basecamp_oauth = session_helper.basecamp_oauth
  gh_oauth = session_helper.gh_oauth

  redirect '/basecamp/login' unless basecamp_oauth.connected?
  redirect '/github/login' unless gh_oauth.connected?

  reportable_todos = (job_result.todos if job_result.is_a? ReportableTodos)
  job_failed = job_result.is_a? JobRepository::FailedJob

  account = basecamp_oauth.bc3_accounts.detect { |a| a.id.to_s == params['account_id'] }
  todolist = account.todolist(params['project_id'], params['todolist_id'])
  erb :todolist_show,
      locals: { account: account, todolist: todolist, reportable_todos: reportable_todos,
                job_failed: job_failed }
end
