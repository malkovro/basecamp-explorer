class ConnectionCenter
  def basecamp
    @basecamp ||= Basecamp::OauthNegotiator.new
  end

  def github
    @github ||= Github::OauthNegotiator.new
  end
end
