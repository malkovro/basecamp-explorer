require_relative 'boot'

negotiator = Basecamp::OauthNegotiator.new
p negotiator.authorize_url

$stdout.puts 'Visit the link above, accept and type the code you received:'
code = $stdin.gets.strip

negotiator.fetch_token(code)

ACCOUNTS = negotiator.accounts.map do |account|
  Basecamp::Account.new(negotiator.authenticated_client, account)
end

if ACCOUNTS.count.positive?
  $stdout.puts '========== YOU HAVE ACCESS TO THE FOLLOWING ACCOUNTS ========'
  ACCOUNTS.each_with_index do |account, _index|
    $stdout.puts "##{account.id} - #{account.name}"
  end
end

$stdout.puts 'The constant ACCOUNTS holds your accounts ready for play!'

$stdout.puts "\nLet' setup your Github connection now:"

gh_negotiator = Github::OauthNegotiator.new
p gh_negotiator.authorize_url

$stdout.puts 'Visit the link above, accept and type the code you received:'
code = $stdin.gets.strip

gh_negotiator.fetch_token(code)
GH_CLIENT = gh_negotiator.authenticated_client
$stdout.puts '========== ALL SET... HAPPY HACKING!! ========'
