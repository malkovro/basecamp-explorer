class StoreReportableWorker
  include Sidekiq::Worker

  attr_reader :id, :gh_access_token, :basecamp_access_token, :account_id, :project_id, :todolist_id

  def parse_options(options)
    @id = options['id']
    @gh_access_token = options['gh_access_token']
    @basecamp_access_token = options['basecamp_access_token']
    @account_id = options['account_id']
    @project_id = options['project_id']
    @todolist_id = options['todolist_id']
  end

  def perform(options)
    parse_options(options)
    mark_pending

    bkb_todos = todolist.completed_todos.map(&method(:barkibu_todo))
    reportable_todos = bkb_todos.select(&:reportable?)

    store_result(reportable_todos)
  rescue StandardError => e
    p "Something wrong happened: #{e.message}"
    p e.backtrace
    mark_failed
  end

  private

  def store_result(todos)
    JobRepository.store id, ReportableTodos.new(todos)
  end

  def mark_pending
    JobRepository.mark_pending(id)
  end

  def mark_failed
    JobRepository.mark_failed(@id) # Could pass the error in there as well to help!
  end

  def barkibu_todo(todo)
    Barkibu::Todo.new(todo, gh_client)
  end

  def gh_client
    Github::Client.new(gh_access_token)
  end

  def basecamp_client
    Basecamp::Client.new(basecamp_access_token)
  end

  def account
    accounts.detect { |a| a.id == account_id }
  end

  def accounts
    request = basecamp_client.class.get("#{Basecamp::OauthNegotiator::AUTHORIZATION_BASE_URL}/authorization.json",
                                        headers: basecamp_client.authorization_header)
    request.parsed_response['accounts'].map do |acc|
      Basecamp::Account.new(basecamp_client, acc)
    end
  end

  def project
    account.projects.detect { |p| p.id == project_id }
  end

  def todolist
    project.todoset.todolists.detect { |tl| tl.id == todolist_id }
  end
end
