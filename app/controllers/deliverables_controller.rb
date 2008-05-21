class DeliverablesController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize, :get_settings

  helper :sort
  include SortHelper
  
  def index
    sort_init "#{Deliverable.table_name}.id", "desc"
    sort_update
    limit = per_page_option
    @deliverable_count = Deliverable.count(:conditions => { :project_id => @project.id })
    @deliverable_pages = Paginator.new self, @deliverable_count, limit, params['page']
    @deliverables = Deliverable.find(:all,
                                     :order => sort_clause,
                                     :conditions => { :project_id => @project.id },
                                     :limit => limit,
                                     :offset => @deliverable_pages.current.offset)

    respond_to do |format|
      format.html { render :action => 'index', :layout => !request.xhr? }
    end
  end
  
  private
  def find_project
    @project = Project.find(params[:id])
  end
  
  def get_settings
    @settings = Setting.plugin_budget_plugin
  end
end
