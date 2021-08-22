module Basecamp
  class Todolist < Model
    def incomplete_todos
      fetch_list todos_url, Todo, completed: false
    end

    def completed_todos
      fetch_list todos_url, Todo, completed: true
    end
  end
end
