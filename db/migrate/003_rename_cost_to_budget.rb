class RenameCostToBudget < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :budget, :decimal, :precision => 15, :scale => 2
    remove_column :deliverables, :cost
  end
  
  def self.down
    add_column :deliverables, :cost, :decimal, :precision => 15, :scale => 2
    remove_column :deliverables, :budget
  end
end
