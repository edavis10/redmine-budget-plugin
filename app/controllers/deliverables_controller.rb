class DeliverablesController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize, :get_settings

  helper :sort
  include SortHelper

  # Main deliverable list
  def index
    sort_init "#{Deliverable.table_name}.id", "desc"
    sort_update 'id' => "#{Deliverable.table_name}.id"

    @deliverable_count = Deliverable.count(:conditions => { :project_id => @project.id})
    @deliverable_pages = Paginator.new self, @deliverable_count, per_page_option, params['page']
    @deliverables = Deliverable.find(:all, 
                                     { 
                                       :conditions => { :project_id => @project.id},
                                       :limit => per_page_option,
                                       :offset => @deliverable_pages.current.offset
                                     }.merge(sort_order)
                                     )

    @deliverables = sort_if_needed @deliverables
    
    @deliverable = Deliverable.new

    @budget = Budget.new(@project.id)

    @display_form = params[:new].present? || @deliverables.empty?

    respond_to do |format|
      format.html { render :action => 'index', :layout => !request.xhr? }
    end
  end
  
  # Action to preview the Deliverable description
  def preview
    @text = params[:deliverable][:description]
    render :partial => 'common/preview'
  end
  
  # Saves a new Deliverable
  def create
    if params[:deliverable][:type] == FixedDeliverable.name
      @deliverable = FixedDeliverable.new(params[:deliverable])
    elsif params[:deliverable][:type] == HourlyDeliverable.name
      @deliverable = HourlyDeliverable.new(params[:deliverable])
    else
      @deliverable = Deliverable.new(params[:deliverable])
    end
    
    @deliverable.project = @project
    @budget = Budget.new(@project.id)
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

  # Builds the edit form for the Deliverable
  def edit
    @deliverable = Deliverable.find_by_id_and_project_id(params[:deliverable_id], params[:id])
  end

  # Updates an existing Deliverable, optionally changing it's type
  def update
    @deliverable = Deliverable.find(params[:deliverable_id])
    
    if params[:deliverable][:type] != @deliverable.class
      @deliverable = @deliverable.change_type(params[:deliverable][:type])
    end
    
    respond_to do |format|
      if @deliverable.update_attributes(params[:deliverable])
        @flash = l(:notice_successful_create)
        format.html { redirect_to :action => 'index', :id => @project.id }
      else
        format.html { render :action => 'edit', :id => @project.id}
      end
    end

    
  end
  
  # Removes the Deliverable
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
    unless params[:deliverable_id] == 'none'
      @query.add_filter("deliverable_id", '=', [params[:deliverable_id]])
    else
      @query.add_filter("deliverable_id", '!*', ['']) # None
      @query.add_filter("status_id", '*', ['']) # All statuses
    end

    session[:query] = {:project_id => @query.project_id, :filters => @query.filters}

    redirect_to :controller => 'issues', :action => 'index', :project_id => @project.id
  end
  
  # Assigns issues to the Deliverable based on their Version
  def bulk_assign_issues
    @deliverable = Deliverable.find_by_id_and_project_id(params[:deliverable_id], @project.id)
    
    render_404 and return unless @deliverable
    render_403 and return unless @deliverable.editable_by?(User.current)
    
    number_updated = @deliverable.assign_issues_by_version(params[:version][:id])
    
    flash[:notice] = l(:message_updated_issues, number_updated)
    redirect_to :action => 'index', :id => @project.id
  end
  
  private
  def find_project
    @project = Project.find(params[:id])
  end
  
  def get_settings
    @settings = Setting.plugin_budget_plugin
  end

  # Sorting orders
  def sort_order
    if session[@sort_name] && %w(score spent progress labor_budget).include?(session[@sort_name][:key])
      return {  }
    else
      return { :order => sort_clause }
    end
  end
  
  # Sort +deliverables+ manually using the virtual fields
  def sort_if_needed(deliverables)
    if session[@sort_name] && %w(score spent progress labor_budget).include?(session[@sort_name][:key])
      case session[@sort_name][:key]
      when "score"
          sorted = deliverables.sort {|a,b| a.score <=> b.score}
      when "spent"
          sorted = deliverables.sort {|a,b| a.spent <=> b.spent}
      when "progress"
          sorted = deliverables.sort {|a,b| a.progress <=> b.progress}
      when "labor_budget"
          sorted = deliverables.sort {|a,b| a.labor_budget <=> b.labor_budget}
      end

      return sorted if session[@sort_name][:order] == 'asc'
      return sorted.reverse! if session[@sort_name][:order] == 'desc'
    else
      return deliverables
    end
  end
  
end
