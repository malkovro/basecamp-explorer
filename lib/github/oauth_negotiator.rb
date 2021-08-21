module Github
  class OauthNegotiator < BaseOauthNegotiator
    AUTHORIZATION_BASE_URL = 'https://github.com'.freeze
    AUTHORIZE_URL = '/login/oauth/authorize'.freeze
    TOKEN_URL = '/login/oauth/access_token'.freeze

    attr_accessor :client, :access_token, :redirect_uri

    def initialize(client_id: ENV['GITHUB_CLIENT_ID'],
                   client_secret: ENV['GITHUB_CLIENT_SECRET'],
                   redirect_uri: ENV['GITHUB_REDIRECT_URI'],
                   client_class: Github::Client)
      super
    end
  end
end
