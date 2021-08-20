module Basecamp
  class Todoset < Model
    def todolists
      return [] unless todolists_count > 0

      client.fetch(todolists_url).map do |todolist|
        Todolist.new(client, todolist)
      end
    end
  end
end