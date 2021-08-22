class GateKeeper
  attr_reader :negotiators

  def initialize
    @negotiators = {}
  end

  def present(service, session)
    session[self.class.name] ||= SecureRandom.uuid

    negotiators[uuid(session)] ||= ConnectionCenter.new
    negotiators[uuid(session)].public_send(service)
  end

  def current(session)
    negotiators[uuid(session)]
  end

  def let_in(session, service, code)
    uuid = uuid(session)
    return unless uuid && negotiators[uuid]

    negotiators[uuid].public_send(service).fetch_token(code)
  end

  private

  def uuid(session)
    session[self.class.name]
  end
end
