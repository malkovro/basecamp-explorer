module Basecamp
  class Todolist < Model
    def todos
      client.fetch(todos_url).map do |todo|
        Todo.new(client, todo)
      end
    end
  end
end
