# require 'gem'

require 'json'
require 'tty-prompt'
require 'faraday'
require_relative './lib/shared'
require_relative './lib/user'
require_relative './lib/api'
require_relative './lib/application'

menu = Application.new()
menu.run