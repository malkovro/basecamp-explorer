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

  def current(session)
    negotiators[uuid(session)]
  end

  def let_in(session, code)
    uuid = uuid(session)
    return unless uuid && negotiators[uuid]

    negotiators[uuid].fetch_token(code)
  end

  private

  def uuid(session)
    session[self.class.name]
  end
end
