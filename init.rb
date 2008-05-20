require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Budget plugin for RedMine'

Redmine::Plugin.register :budget_plugin do
  name 'Budget'
  author 'Eric Davis <edavis@littlestreamsoftware.com>'
  description 'This is a budget plugin to track deliverables and budgets on a project'
  version '0.0.0'
end
