module Basecamp
  class Todolist < Model
    def todos
      fetch_list todos_url, Todo
    end
  end
end
