require_relative 'boot'

$negotiator = Basecamp::OauthNegotiator.new
p $negotiator.authorize_url

$stdout.puts 'Visit the link above, accept and type the code you received:'
code = $stdin.gets.strip

$negotiator.token(code)

accounts = $negotiator.accounts

if accounts.count > 0
  $stdout.puts '========== YOU HAVE ACCESS TO THE FOLLOWING ACCOUNTS ========'
  accounts.each_with_index do |account, index|
    $stdout.puts "##{account['id']} - #{account['name']}"
  end
end

$client = $negotiator.authenticated_client
$stdout.puts "You can play around with $client authenticated over those accounts! Good hacking!"
