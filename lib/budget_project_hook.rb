class BudgetProjectHook  < Redmine::Hook::ViewListener
  def model_project_copy_before_save(context = {})
    source = context[:source_project]
    destination = context[:destination_project]

    if source.module_enabled?(:budget_module)
      Deliverable.find(:all, :conditions => {:project_id => source.id}).each do |source_deliverable|
        destination_deliverable = source_deliverable.class.new # STI classes

        # Copy attribute except for the ones that have wrapped
        # accessors, use read/write attribute for them
        destination_deliverable.attributes = source_deliverable.attributes.except("project_id", "profit", "materials", "overhead")

        destination_deliverable.write_attribute(:profit, source_deliverable.read_attribute(:profit))
        destination_deliverable.write_attribute(:profit_percent, source_deliverable.read_attribute(:profit_percent))
        destination_deliverable.write_attribute(:materials, source_deliverable.read_attribute(:materials))
        destination_deliverable.write_attribute(:materials_percent, source_deliverable.read_attribute(:materials_percent))
        destination_deliverable.write_attribute(:overhead, source_deliverable.read_attribute(:overhead))
        destination_deliverable.write_attribute(:overhead_percent, source_deliverable.read_attribute(:overhead_percent))

        destination_deliverable.project = destination
        destination_deliverable.save # Need to save here because there is no relation on project to deliverable
      end      
    end
  end
end
