class AddFirebaseLinkToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :dynamic_link, :string
  end
end
