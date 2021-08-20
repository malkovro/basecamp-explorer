require_relative 'boot'

$negotiator = Basecamp::OauthNegotiator.new
p $negotiator.authorize_url

$stdout.puts 'Visit the link above, accept and type the code you received:'
code = $stdin.gets.strip

$negotiator.token(code)

accounts = $negotiator.accounts

if accounts.count > 0
  $stdout.puts '========== CHOOSE THE ACCOUNT ========'
  accounts.each_with_index do |account, index|
    $stdout.puts "Type #{index+1} for #{account['name']}"
  end
  chosen_index = $stdin.gets.strip.to_i - 1
else
  chosen_index = 0
end
account = accounts[chosen_index]
$client = $negotiator.authenticated_client(account['id'])
$stdout.puts "You can play around in #{account['name']} with $client for this account! Good hacking!"

