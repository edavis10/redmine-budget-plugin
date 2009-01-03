require 'redmine'

# Patches to the Redmine core.  Will not work in development mode
require_dependency 'issue_patch'
require_dependency 'query_patch'

# Hooks
require_dependency 'budget_issue_hook'
require_dependency 'budget_project_hook'

RAILS_DEFAULT_LOGGER.info 'Starting Budget plugin for RedMine'

Redmine::Plugin.register :budget_plugin do
  name 'Budget'
  author 'Eric Davis <edavis@littlestreamsoftware.com>'
  description 'Budget is a plugin to manage the set of deliverables for each project, automatically calculating key performance indicators.'
  version '0.1.0'
  
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
