class AddOrganizationIdToDashboard < ActiveRecord::Migration[7.0]
  def change
     add_column :parties, :organization_id, :integer
     add_column :agreements, :organization_id, :integer
     add_column :dashboarddata, :organization_id, :integer
     add_index :parties, :organization_id
     add_index :agreements, :organization_id
     add_index :dashboarddata, :organization_id
  end
end
