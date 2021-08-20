require_relative 'boot'

$negotiator = Basecamp::OauthNegotiator.new
p $negotiator.authorize_url

$stdout.puts 'Visit the link above, accept and type the code you received:'
code = $stdin.gets.strip

$negotiator.token(code)

ACCOUNTS = $negotiator.accounts.map do |account|
  Basecamp::Account.new($negotiator.authenticated_client, account)
end

if ACCOUNTS.count > 0
  $stdout.puts '========== YOU HAVE ACCESS TO THE FOLLOWING ACCOUNTS ========'
  ACCOUNTS.each_with_index do |account, index|
    $stdout.puts "##{account.id} - #{account.name}"
  end
end

$client = $negotiator.authenticated_client
$stdout.puts "The constant ACCOUNTS holds your accounts ready for play! Good hacking!"
