module Basecamp
  class OauthNegotiator
    AUTHORIZATION_BASE_URL = 'https://launchpad.37signals.com'.freeze
    AUTHORIZE_URL = '/authorization/new'.freeze
    TOKEN_URL = '/authorization/token'.freeze

    attr_accessor :client, :access_token, :redirect_url

    def initialize(access_key: ENV['BASECAMP_INTEGRATION_ACCESS_KEY'],
                   access_secret: ENV['BASECAMP_INTEGRATION_ACCESS_SECRET'],
                   redirect_url: ENV['BASECAMP_INTEGRATION_REDIRECT_URL'])
      self.redirect_url = redirect_url
      self.client = OAuth2::Client.new(access_key, access_secret, site: AUTHORIZATION_BASE_URL,
                                                                  authorize_url: AUTHORIZE_URL, token_url: TOKEN_URL)
    end

    def connected?
      !access_token.nil?
    end

    def authorize_url
      "#{client.auth_code.authorize_url(redirect_uri: redirect_url)}&type=web_server"
    end

    def fetch_token(code)
      @access_token = client.auth_code.get_token(code, redirect_uri: redirect_url, type: 'web_server')

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

    def authenticated_client
      @authenticated_client ||= Basecamp::Client.new(access_token)
    end
  end
end
