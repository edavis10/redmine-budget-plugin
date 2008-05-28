class AddRateToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :rate, :decimal, :precision => 15, :scale => 2
  end
  
  def self.down
    remove_column :members, :rate
  end
end
