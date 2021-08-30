module Github
  class Client < SimpleDelegator
    def initialize(access_token)
      @pull_requests = {}
      super(Octokit::Client.new(access_token: access_token))
    end

    def pull_request(repository, pull_request_number)
      @pull_requests["#{repository}/#{pull_request_number}"] ||= PullRequest.new(self, repository, super)
    end
  end
end
