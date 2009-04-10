require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'
require 'issue_patch'
require 'query_patch'
Dispatcher.to_prepare do
  Issue.send(:include, IssuePatch)
  Query.send(:include, QueryPatch)
end

# Hooks
require_dependency 'budget_issue_hook'
require_dependency 'budget_project_hook'

RAILS_DEFAULT_LOGGER.info 'Starting Budget plugin for RedMine'

Redmine::Plugin.register :budget_plugin do
  name 'Budget'
  author 'Eric Davis <edavis@littlestreamsoftware.com>'
  description 'Budget is a plugin to manage the set of deliverables for each project, automatically calculating key performance indicators.'
  version '0.2.0'
  
  settings :default => {
    'budget_nonbillable_overhead' => '',
    'budget_materials' => '',
    'budget_profit' => ''
  }, :partial => 'settings/budget_settings'

  
  project_module :budget_module do
    permission :view_budget, { :deliverables => [:index, :issues]}
    permission :manage_budget, { :deliverables => [:new, :edit, :create, :update, :destroy, :preview, :bulk_assign_issues]}
  end
  
  menu :project_menu, :budget, :controller => "deliverables", :action => 'index'
end
