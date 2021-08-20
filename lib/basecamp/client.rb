module Basecamp
  class Client
    include HTTParty

    base_uri '3.basecampapi.com'
    headers 'User-Agent': 'KPI Extractor (leo@barkibu.com)'

    attr_accessor :project_id, :account, :access_token

    def initialize(access_token, account:)
      self.account = account
      self.access_token = access_token
      self.project_id = project_id
    end

    def projects
      request = self.class.get("/#{account}/projects.json", headers: authorization_header)
      request.parsed_response
    end

    def authorization_header
      # Nice TODO Check if the token is expired and do something if it is!!
      { 'Authorization': "Bearer #{access_token.token}" }
    end
  end
end