class AddDataFieldsToDeliverablesForCalculations < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :overhead, :decimal, :precision => 15, :scale => 2
    add_column :deliverables, :materials, :decimal, :precision => 15, :scale => 2
    add_column :deliverables, :profit, :decimal, :precision => 15, :scale => 2
    add_column :deliverables, :cost_per_hour, :decimal, :precision => 15, :scale => 2
    add_column :deliverables, :total_hours, :decimal, :precision => 15, :scale => 2
    add_column :deliverables, :fixed_cost, :decimal, :precision => 15, :scale => 2
  end
  
  def self.down
    remove_column :deliverables, :overhead
    remove_column :deliverables, :materials
    remove_column :deliverables, :profit
    remove_column :deliverables, :cost_per_hour
    remove_column :deliverables, :total_hours
    remove_column :deliverables, :fixed_cost
  end
end
