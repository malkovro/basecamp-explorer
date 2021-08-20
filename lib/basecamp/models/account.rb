module Basecamp
  class Account < Model
    def projects
      client.fetch(href + '/projects.json').map do |project|
        Project.new(client, project)
      end
    end
  end
end