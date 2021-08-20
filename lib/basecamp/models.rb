module Basecamp
  class Model < OpenStruct
    attr_reader :client

    def initialize(client, args)
      @client = client
      super(args)
    end
  end
end

require_relative 'models/account'
require_relative 'models/project'
require_relative 'models/todoset'
require_relative 'models/todolist'
require_relative 'models/todo'
require_relative 'models/comment'

