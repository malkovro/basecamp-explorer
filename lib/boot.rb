require 'dotenv/load'
require 'oauth2'
require 'httparty'

require_relative 'version'

require_relative 'basecamp/oauth_negotiator'
require_relative 'basecamp/client'
require_relative 'basecamp/models'

require_relative 'barkibu/comment'
