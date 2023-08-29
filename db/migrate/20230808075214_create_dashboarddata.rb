class CreateDashboarddata < ActiveRecord::Migration[7.0]
  def change
    create_table :dashboarddata do |t|
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

      t.timestamps
    end
  end
end
