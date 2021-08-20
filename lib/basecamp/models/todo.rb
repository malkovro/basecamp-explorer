module Basecamp
  class Todo < Model
    def comments
      return [] unless comments_count.positive?

      fetch_list comments_url, Comment
    end
  end
end
