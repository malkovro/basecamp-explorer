module Github
  class Client < SimpleDelegator
    def initialize(access_token)
      super(Octokit::Client.new(access_token: access_token))
    end

    def pull_request(repository, options)
      PullRequest.new(self, repository, super)
    end
  end
end
