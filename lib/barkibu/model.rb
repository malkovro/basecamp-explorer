module Barkibu
  class Model < SimpleDelegator
    attr_reader :gh_client

    def initialize(todo, gh_client)
      @gh_client = gh_client
      super(todo)
    end
  end
end
