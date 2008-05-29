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

    @deliverable = Deliverable.new

    @budget = Budget.new(@project.id)

    respond_to do |format|
      format.html { render :action => 'index', :layout => !request.xhr? }
    end
  end
  
  def preview
    @text = params[:deliverable][:description]
    render :partial => 'common/preview'
  end
  
  def create
    if params[:deliverable][:type] == FixedDeliverable.name
      @deliverable = FixedDeliverable.new(params[:deliverable])
    elsif params[:deliverable][:type] == HourlyDeliverable.name
      @deliverable = HourlyDeliverable.new(params[:deliverable])
    else
      @deliverable = Deliverable.new(params[:deliverable])
    end
    
    @deliverable.project = @project
    respond_to do |format|
      if @deliverable.save
        @flash = l(:notice_successful_create)
        format.html { redirect_to :action => 'index' }
        format.js { render :action => 'create.js.rjs'}
      else
        format.js { render :action => 'create_error.js.rjs'}
      end
    end

  end

  def edit
    @deliverable = Deliverable.find_by_id_and_project_id(params[:deliverable_id], params[:id])
  end

  def update
    # TODO: Handle type change
    @deliverable = Deliverable.find(params[:deliverable_id])
    
    respond_to do |format|
      if @deliverable.update_attributes(params[:deliverable])
        @flash = l(:notice_successful_create)
        format.html { redirect_to :action => 'index', :id => @project.id }
      else
        format.html { render :action => 'edit', :id => @project.id}
      end
    end

    
  end
  
  def destroy
    @deliverable = Deliverable.find_by_id_and_project_id(params[:deliverable_id], @project.id)
    
    render_404 and return unless @deliverable
    render_403 and return unless @deliverable.editable_by?(User.current)
    @deliverable.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to :action => 'index', :id => @project.id
  end
  
  # Create a query in the session and redirects to the issue list with that query
  def issues
    @query = Query.new(:name => "_")
    @query.project = @project
    @query.add_filter("deliverable_id", '=', [params[:deliverable_id]])
    session[:query] = {:project_id => @query.project_id, :filters => @query.filters}

    redirect_to :controller => 'issues', :action => 'index', :project_id => @project.id
  end
  
  private
  def find_project
    @project = Project.find(params[:id])
  end
  
  def get_settings
    @settings = Setting.plugin_budget_plugin
  end
end
