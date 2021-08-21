module Github
  class Model < OpenStruct
    attr_reader :client

    def initialize(client, args)
      @client = client
      super(args)
    end
  end
end
