# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_24_103646) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_keys", force: :cascade do |t|
    t.string "key_id"
    t.string "secret_key"
    t.boolean "active", default: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_access_keys_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agreements", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.index ["deleted_at"], name: "index_agreements_on_deleted_at"
    t.index ["organization_id"], name: "index_agreements_on_organization_id"
    t.index ["party_id"], name: "index_agreements_on_party_id"
    t.index ["uid"], name: "index_agreements_on_uid", unique: true
    t.index ["user_id"], name: "index_agreements_on_user_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "dashboarddata", force: :cascade do |t|
    t.integer "compliant_count", null: false
    t.integer "expired_insurance_count", null: false
    t.integer "expiring_insurance_count", null: false
    t.integer "in_default_count", null: false
    t.integer "no_coverage_count", null: false
    t.integer "non_compliant_count", null: false
    t.integer "pending_review_count", null: false
    t.integer "total_deficient_requirements_count", null: false
    t.float "month_1_compliance_rate", null: false
    t.float "month_2_compliance_rate", null: false
    t.float "month_3_compliance_rate", null: false
    t.float "month_4_compliance_rate", null: false
    t.float "month_5_compliance_rate", null: false
    t.float "month_6_compliance_rate", null: false
    t.integer "compliant_parties_count"
    t.integer "non_compliant_parties_count"
    t.float "party_month_1_compliance_rate"
    t.float "party_month_2_compliance_rate"
    t.float "party_month_3_compliance_rate"
    t.float "party_month_4_compliance_rate"
    t.float "party_month_5_compliance_rate"
    t.float "party_month_6_compliance_rate"
    t.integer "compliant_coverages_count"
    t.integer "total_coverages_count"
    t.float "coverage_month_1_compliance_rate"
    t.float "coverage_month_2_compliance_rate"
    t.float "coverage_month_3_compliance_rate"
    t.float "coverage_month_4_compliance_rate"
    t.float "coverage_month_5_compliance_rate"
    t.float "coverage_month_6_compliance_rate"
    t.integer "expired_parties_count"
    t.integer "expiring_parties_count"
    t.integer "in_default_parties_count"
    t.integer "pending_review_parties_count"
    t.integer "parties_with_days_in_status_over_a_month"
    t.integer "expired_parties_over_ninety_days"
    t.integer "expiring_parties_over_ninety_days"
    t.integer "parties_defaulted_last_ninety_days"
    t.integer "non_compliant_coverages_count"
    t.integer "no_coverage_coverages_count"
    t.integer "expired_coverages_count"
    t.integer "expiring_coverages_count"
    t.integer "no_coverage_over_ninety_days_count"
    t.integer "expired_coverage_over_ninety_days_count"
    t.integer "current_non_compliant_over_ninety_days_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.index ["organization_id"], name: "index_dashboarddata_on_organization_id"
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "identifier", default: 0
    t.string "push_token"
    t.string "arn"
    t.string "os"
    t.string "model"
    t.string "app"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_blacklists_on_jti", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parties", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.index ["organization_id"], name: "index_parties_on_organization_id"
    t.index ["slug"], name: "index_parties_on_slug", unique: true
    t.index ["uid"], name: "index_parties_on_uid", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "active_status", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "photo_path"
    t.integer "active_status", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dynamic_link"
    t.string "jti", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "deleted_at"
    t.datetime "soft_deleted_at"
    t.datetime "last_activity_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["soft_deleted_at"], name: "index_users_on_soft_deleted_at"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "devices", "users"
  add_foreign_key "posts", "users"
end
