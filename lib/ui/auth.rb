GATE_KEEPER = GateKeeper.new

get '/' do
  oauth_negotiator = GATE_KEEPER.present(session)
  redirect oauth_negotiator.authorize_url
end

get '/token' do
  oauth_negotiator = GATE_KEEPER.let_in(session, params['code'])

  return redirect '/' unless oauth_negotiator

  oauth_negotiator.accounts.to_json
end
