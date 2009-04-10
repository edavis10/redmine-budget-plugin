require_dependency 'query'

# Patches Redmine's Queries dynamically, adding the Deliverable
# to the available query columns
module QueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      base.add_available_column(QueryColumn.new(:deliverable_subject, :sortable => "#{Deliverable.table_name}.subject"))
      
      alias_method :redmine_available_filters, :available_filters
      alias_method :available_filters, :budget_available_filters
    end

  end
  
  module ClassMethods
    
    # Setter for +available_columns+ that isn't provided by the core.
    def available_columns=(v)
      self.available_columns = (v)
    end

    # Method to add a column to the +available_columns+ that isn't provided by the core.
    def add_available_column(column)
      self.available_columns << (column)
    end
  end
  
  module InstanceMethods
    
    # Wrapper around the +available_filters+ to add a new Deliverable filter
    def budget_available_filters
      @available_filters = redmine_available_filters
      
      if project
        budget_filters = { "deliverable_id" => { :type => :list_optional, :order => 14,
            :values => Deliverable.find(:all, :conditions => ["project_id IN (?)", project], :order => 'subject ASC').collect { |d| [d.subject, d.id.to_s]}
          }}
      else
        budget_filters = { }
      end
      return @available_filters.merge(budget_filters)
    end
  end    
end


