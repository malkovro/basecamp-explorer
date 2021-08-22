class ReportableTodos
  attr_reader :todos

  def initialize(todos)
    @todos = todos
  end

  def marshal_dump
    {
      gh_access_token: todos.first&.gh_client&.access_token,
      basecamp_access_token: todos.first&.client&.access_token,
      todos: todos.map(&:to_h)
    }
  end

  def marshal_load(gh_access_token:, basecamp_access_token:, todos:)
    basecamp_client = Basecamp::Client.new(basecamp_access_token)
    gh_client = Github::Client.new(gh_access_token)

    @todos = todos.map do |todo|
      Barkibu::Todo.new(Basecamp::Todo.new(basecamp_client, todo), gh_client)
    end
  end
end
