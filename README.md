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

## What's next on my plate

### _Can we estimate the lead time of a todo ?_

Pseudo-code

```ruby
def lead_time_estimate(todo)
  return unless todo.completed?

  pr_comment = todo.detect &:mention_prs?

  return unless pr_comment

  pr = PR.fetch(pr_comment.pr_number)

  work_started_comment = todo.detect &:work_started?

  return unless work_started_comment

  pr.find_release.created_at - work_started_comment.created_at
end
```

What this pseudo-code is bad at?

- Todos were not moved to in progress when work actually started... 🤷🏽 Nothing I can do ...
- PR not mentioned on the Todo... 🤷🏽 Nothing I can do ...
- Multiple todos on the same PR... We should group by PR and take the biggest _lead_time_
- Task is marked as complete before actually being part of a Release 👽🗿

### _Can we deploy with a one-click button on Heroku and get those lead time through click-click ?_

[![Deploy Me](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
