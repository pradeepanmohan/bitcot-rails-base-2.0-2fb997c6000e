class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.text "name"
      t.text "address_line_1"
      t.text "address_line_2"
      t.text "city"
      t.text "state"
      t.text "postal_code"
      t.text "phone"
      t.text "contact_name"
      t.text "fax"
      t.text "email"
      t.text "country"
      t.text "slug", null: false
    
      t.text "time_zone", default: "America/New_York", null: false


      t.timestamps
    end
  end
end
