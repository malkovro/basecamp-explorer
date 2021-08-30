module Basecamp
  class Account < Model
    def projects
      fetch_list "#{href}/projects.json", Project
    end

    def todolist(project_id, todolist_id)
      fetch("/#{id}/buckets/#{project_id}/todolists/#{todolist_id}.json", Todolist)
    end
  end
end
