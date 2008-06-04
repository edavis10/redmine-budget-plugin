class RenameDueDateToDue < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :due, :date
    
    Deliverable.reset_column_information
    
    Deliverable.find(:all).each do |deliverable|
      deliverable.update_attribute(:due, deliverable.due_date)
    end
    
    remove_column :deliverables, :due_date
  end
  
  def self.down
    add_column :deliverables, :due_date, :date
    
    Deliverable.reset_column_information
    
    Deliverable.find(:all).each do |deliverable|
      deliverable.update_attribute(:due_date, deliverable.due)
    end
    
    remove_column :deliverables, :due
  end
end
