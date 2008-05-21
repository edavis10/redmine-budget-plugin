class RenameCostToBudget < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :budget, :decimal
    remove_column :deliverables, :cost
  end
  
  def self.down
    add_column :deliverables, :cost, :decimal
    remove_column :deliverables, :budget
  end
end
