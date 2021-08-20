## KPI Extractor Integration with Basecamp

Basecamp exposes a nice API to consumes its data, this project tries to wrap a HTTParty client around those endpoints and provides a CLI to allow exploring its data.

## Setup

First things first, grab yourself an access key and access secret registering your own application on https://launchpad.37signals.com/integrations.

Copy the .env.example into .env and paste those there!

## Getting our hands dirty

Second, either launch `bundle install` locally 🐷 or if you like to keep things tidy use the docker setup:

```cmd
docker-compose run --rm explorer
/ *** /
Creating basecamp_playground_explorer_run ... done
"https://launchpad.37signals.com/authorization/new?client_id=**********&redirect_uri=http%3A%2F%2Fnotyet.barkibu.com&response_type=code&type=web_server"
Visit the link above, accept and type the code you received:
8735406d
========== CHOOSE THE ACCOUNT ========
Type 1 for Barkibu
1
You can play around in Barkibu with $client for this account! Good hacking!
irb(main):001:0>
```

Now you have a irb session with an authenticated client for the account you selected ready to hack!
