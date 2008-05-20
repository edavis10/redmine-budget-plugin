class DeliverablesController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize, :get_settings

  def index
    @deliverables = Deliverable.find_all_by_project_id(@project.id)
  end
  
  private
  def find_project
    @project = Project.find(params[:id])
  end
  
  def get_settings
#    @settings = Setting.plugin_budget_plugin
  end
end
