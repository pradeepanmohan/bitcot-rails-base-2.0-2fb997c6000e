class AddSoftDeletedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :soft_deleted_at, :datetime
    add_index :users, :soft_deleted_at
  end
end
