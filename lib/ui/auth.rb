get '/:service/login' do
  oauth_negotiator = GATE_KEEPER.present(params['service'], session)
  redirect oauth_negotiator.authorize_url
end

get '/:service/token' do
  oauth_negotiator = GATE_KEEPER.let_in(session, params['service'], params['code'])

  return redirect "/#{params['service']}/login" unless oauth_negotiator

  redirect '/'
end
