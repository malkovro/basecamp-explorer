class SessionHelper
  attr_accessor :session

  def initialize(session)
    self.session = session
  end

  def basecamp_oauth
    @basecamp_oauth ||= Basecamp::OauthNegotiator.from_hash(session['basecamp_token'])
  end

  def gh_oauth
    @gh_oauth ||= Github::OauthNegotiator.from_hash(session['github_token'])
  end

  def fetch_token(service, code)
    oauth_service = oauth(service)

    return unless oauth_service

    oauth_service.fetch_token(code)
    session["#{service}_token"] = oauth_service.access_token.to_hash
    oauth_service
  end

  def oauth(service)
    case service
    when 'basecamp'
      basecamp_oauth
    when 'github'
      gh_oauth
    end
  end
end
