get '/login' do
  oauth_negotiator = GATE_KEEPER.present(session)
  redirect oauth_negotiator.authorize_url
end

get '/token' do
  oauth_negotiator = GATE_KEEPER.let_in(session, params['code'])

  return redirect '/login' unless oauth_negotiator

  redirect '/'
end
