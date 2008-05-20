# Empty redmine plguin
require 'redmine'

# TODO: Change this to use the name of your plugin
RAILS_DEFAULT_LOGGER.info 'Starting Empty plugin for RedMine'

# TODO: Change the name 
Redmine::Plugin.register :empty_plugin do
  name 'Empty plugin'
  author 'Eric Davis'
  description 'This is an empty plugin for Redmine that is used to start new plugins'
  version '0.0.0'
end
