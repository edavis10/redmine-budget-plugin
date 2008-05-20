require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Budget plugin for RedMine'

Redmine::Plugin.register :budget_plugin do
  name 'Budget'
  author 'Eric Davis <edavis@littlestreamsoftware.com>'
  description 'This is a budget plugin to track deliverables and budgets on a project'
  version '0.0.0'
  
  project_module :budget_module do
    permission :view_budget, { :deliverables => [:index]}
    permission :manage_budget, { :deliverables => [:new, :edit, :create, :update, :destroy]}
  end
  
  menu :project_menu, :budget, :controller => "deliverables", :action => 'index'
end
