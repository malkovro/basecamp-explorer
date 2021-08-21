class BaseOauthNegotiator
  AUTHORIZATION_BASE_URL = 'base_url'.freeze
  AUTHORIZE_URL = '/login/oauth/authorize'.freeze
  TOKEN_URL = '/login/oauth/access_token'.freeze

  attr_accessor :client, :access_token, :redirect_uri, :client_class

  def initialize(client_id:, client_secret:, redirect_uri:, client_class:)
    self.redirect_uri = redirect_uri
    self.client_class = client_class
    self.client = OAuth2::Client.new(
      client_id,
      client_secret,
      site: self.class::AUTHORIZATION_BASE_URL,
      authorize_url: self.class::AUTHORIZE_URL, token_url: self.class::TOKEN_URL
    )
  end

  def connected?
    !access_token.nil?
  end

  def authorize_url
    client.auth_code.authorize_url(redirect_uri: redirect_uri)
  end

  def fetch_token(code)
    @access_token = client.auth_code.get_token(code, redirect_uri: redirect_uri)

    self
  end

  def authenticated_client
    @authenticated_client ||= client_class.new(access_token.token)
  end
end
