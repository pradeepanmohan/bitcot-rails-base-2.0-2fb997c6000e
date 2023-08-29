class CreateAgreements < ActiveRecord::Migration[7.0]
  def change
    create_table :agreements do |t|
      t.integer "party_id", null: false
      t.datetime "deleted_at"
      t.text "name", null: false
      t.date "starts_on"
      t.date "ends_on"
      t.integer "agreement_type", default: 0
      t.integer "agreement_status", default: 0
      t.text "uid", null: false
      t.text "description", default: ""
      t.boolean "compliance_processed", default: false, null: false
      t.datetime "defaulted_at"
      t.datetime "requirement_set_applied_at"
      t.integer "user_id"
      t.text "status"
      t.datetime "last_compliance_update"
      t.index ["user_id"], name: "index_agreements_on_user_id"
    
      t.index ["deleted_at"], name: "index_agreements_on_deleted_at"
      t.index ["party_id"], name: "index_agreements_on_party_id"
      t.index ["uid"], name: "index_agreements_on_uid", unique: true

      t.timestamps
    end
  end
end
