module Basecamp
  class Todo < Model
    def comments
      return [] unless comments_count.positive?

      client.fetch(comments_url).map do |comment|
        Comment.new(client, comment)
      end
    end
  end
end
