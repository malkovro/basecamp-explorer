module Basecamp
  class Client
    include HTTParty

    base_uri '3.basecampapi.com'
    headers 'User-Agent': "#{ENV['BASECAMP_INTEGRATION_NAME']} (#{ENV['BASECAMP_INTEGRATION_CONTACT_EMAIL']})"

    attr_accessor :project_id, :access_token

    def initialize(access_token)
      self.access_token = access_token
      self.project_id = project_id
    end

    def authorization_header
      # Nice TODO Check if the token is expired and do something if it is!!
      { 'Authorization': "Bearer #{access_token}" }
    end

    def fetch(url)
      self.class.get(url, headers: authorization_header)
    end
  end
end
