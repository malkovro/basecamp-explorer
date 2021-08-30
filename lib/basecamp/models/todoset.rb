module Basecamp
  class Todoset < Model
    def todolists
      return [] unless todolists_count.positive?

      fetch_list(todolists_url, Todolist)
    end

    def archived_todolists
      fetch_list(todolists_url, Todolist, status: :archived)
    end
  end
end
