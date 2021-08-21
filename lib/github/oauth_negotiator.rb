module Github
  class OauthNegotiator < BaseOauthNegotiator
    AUTHORIZATION_BASE_URL = 'https://github.com'.freeze
    AUTHORIZE_URL = '/login/oauth/authorize'.freeze
    TOKEN_URL = '/login/oauth/access_token'.freeze

    def initialize(client_id: ENV['GITHUB_CLIENT_ID'],
                   client_secret: ENV['GITHUB_CLIENT_SECRET'],
                   redirect_uri: ENV['GITHUB_REDIRECT_URI'],
                   client_class: Github::Client)
      super
    end

    def scopes
      ['repo'] # A bit too broad but we'll see later what we actually need
    end
  end
end
