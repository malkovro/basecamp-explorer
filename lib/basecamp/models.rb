module Basecamp
  class Model < OpenStruct
    attr_reader :client

    def initialize(client, args)
      @client = client
      super(args)
    end

    def fetch(url, child_class)
      child_class.new(client, client.fetch(url))
    end

    def fetch_list(url, child_class)
      client.fetch(url).map do |model|
        child_class.new(client, model)
      end
    end
  end
end

require_relative 'models/account'
require_relative 'models/project'
require_relative 'models/todoset'
require_relative 'models/todolist'
require_relative 'models/todo'
require_relative 'models/comment'
