class AddPercentageFieldsToDeliverables < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :overhead_percent, :integer
    add_column :deliverables, :materials_percent, :integer
    add_column :deliverables, :profit_percent, :integer
  end
  
  def self.down
    remove_column :deliverables, :overhead_percent
    remove_column :deliverables, :materials_percent
    remove_column :deliverables, :profit_percent
  end
end
