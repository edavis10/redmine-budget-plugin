require_dependency 'query'

module QueryPatch
  def self.included(base)
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
    def hello
      puts 'hello'
    end

    def available_columns=(v)
      self.available_columns = (v)
    end

    def add_available_column(column)
      self.available_columns << (column)
    end
  end
  
  module InstanceMethods
    def budget_available_filters
      @available_filters = redmine_available_filters
      
      if project
        budget_filters = { "deliverable_id" => { :type => :list, :order => 14,
            :values => Deliverable.find(:all, :conditions => ["project_id IN (?)", project]).collect { |d| [d.subject, d.id.to_s]}
          }}
      else
        budget_filters = { }
      end
      return @available_filters.merge(budget_filters)
    end
  end    
end

# Add module to Query
Query.send(:include, QueryPatch)


