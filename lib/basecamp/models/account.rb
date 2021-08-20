module Basecamp
  class Account < Model
    def projects
      fetch_list "#{href}/projects.json", Project
    end
  end
end
