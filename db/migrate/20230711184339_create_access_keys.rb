class CreateAccessKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :access_keys do |t|
      t.string :key_id
      t.string :secret_key
      t.boolean :active, default: true
      t.references :user
      t.timestamps
    end
  end
end
