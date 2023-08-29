class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.references :user, foreign_key: true
      t.integer :identifier, default: 0
      t.string :push_token
      t.string :arn
      t.string :os
      t.string :model
      t.string :app

      t.timestamps
    end
  end
end
