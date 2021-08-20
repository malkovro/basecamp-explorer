class GateKeeper
  attr_reader :negotiators

  def initialize
    @negotiators = {}
  end

  def present(session)
    uuid = SecureRandom.uuid
    session[self.class.name] = uuid
    negotiators[uuid] = Basecamp::OauthNegotiator.new
  end

  def let_in(session, code)
    uuid = session[self.class.name]
    return unless uuid && negotiators[uuid]

    negotiators[uuid].fetch_token(code)
  end
end
