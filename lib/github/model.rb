module Github
  class Model < SimpleDelegator
    attr_reader :client, :repository

    def initialize(client, repository, args)
      @client = client
      @repository = repository
      super(args)
    end
  end
end
