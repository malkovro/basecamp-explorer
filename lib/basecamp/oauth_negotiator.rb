module Basecamp
  class OauthNegotiator < BaseOauthNegotiator
    AUTHORIZATION_BASE_URL = 'https://launchpad.37signals.com'.freeze
    AUTHORIZE_URL = '/authorization/new'.freeze
    TOKEN_URL = '/authorization/token'.freeze

    def initialize(client_id: ENV['BASECAMP_INTEGRATION_ACCESS_KEY'],
                   client_secret: ENV['BASECAMP_INTEGRATION_ACCESS_SECRET'],
                   redirect_uri: ENV['BASECAMP_INTEGRATION_REDIRECT_URL'],
                   client_class: Basecamp::Client)
      super
    end

    def authorize_url
      "#{client.auth_code.authorize_url(redirect_uri: redirect_uri)}&type=web_server"
    end

    def fetch_token(code)
      @access_token = client.auth_code.get_token(code, redirect_uri: redirect_uri, type: 'web_server')

      self
    end

    def accounts
      return [] unless access_token

      request = HTTParty.get("#{AUTHORIZATION_BASE_URL}/authorization.json",
                             headers: { 'Authorization': "Bearer #{access_token.token}" })
      request.parsed_response['accounts']
    end

    def bc3_accounts
      accounts.map do |account|
        Basecamp::Account.new(authenticated_client, account)
      end
    end
  end
end
