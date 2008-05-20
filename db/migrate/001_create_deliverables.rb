class CreateDeliverables < ActiveRecord::Migration
  def self.up
    create_table :deliverables do |t|
      t.column :subject, :string
      t.column :due_date, :date
      t.column :description, :text
      t.column :type, :string
      t.column :cost, :decimal
      t.column :project_manager_signoff, :boolean, :default => false
      t.column :client_signoff, :boolean, :default => false
    end
  end
  
  def self.down
    drop_table :deliverables
  end
end
