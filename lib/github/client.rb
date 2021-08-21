module Github
  class Client < SimpleDelegator
    def initialize(access_token)
      super(Octokit::Client.new(access_token: access_token))
    end
  end
end
