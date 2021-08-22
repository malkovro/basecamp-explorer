module Basecamp
  class Model < OpenStruct
    attr_reader :client

    def initialize(client, args)
      @client = client
      super(args)
    end

    def fetch(url, child_class)
      child_class.new(client, client.fetch(url).parsed_response)
    end

    def fetch_list(url, child_class, **params)
      Paginable.new(client, url, child_class, params)
    end
  end
end

require_relative 'models/paginable'
require_relative 'models/account'
require_relative 'models/project'
require_relative 'models/todoset'
require_relative 'models/todolist'
require_relative 'models/todo'
require_relative 'models/comment'
