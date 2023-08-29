class CreateParties < ActiveRecord::Migration[7.0]
  def change
    create_table :parties do |t|
       t.text "name", null: false
      t.text "address_line_1"
      t.text "address_line_2"
      t.text "city"
      t.text "state"
      t.text "status"
      t.text "postal_code"
      t.text "phone"
      t.text "fax"
      t.text "country"
      t.text "uid", null: false
      t.text "slug", null: false
      t.integer "user_id", null: false
      t.index ["slug"], name: "index_parties_on_slug", unique: true
      t.index ["uid"], name: "index_parties_on_uid", unique: true

      t.timestamps
    end
  end
end
