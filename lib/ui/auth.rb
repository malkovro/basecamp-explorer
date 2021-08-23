get '/:service/login' do
  session_helper = SessionHelper.new(session)
  redirect session_helper.oauth(params['service']).authorize_url
end

get '/:service/token' do
  session_helper = SessionHelper.new(session)
  oauth_negotiator = session_helper.fetch_token(params['service'], params['code'])
  return redirect "/#{params['service']}/login" unless oauth_negotiator

  redirect '/'
end
