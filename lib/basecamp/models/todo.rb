module Basecamp
  class Todo < Model
    def comments
      return [] unless comments_count > 0

      client.fetch(comments_url).map do |comment|
        Comment.new(client, comment)
      end
    end
  end
end
