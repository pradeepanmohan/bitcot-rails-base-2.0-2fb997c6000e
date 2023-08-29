require 'faker'
require 'securerandom'

def generate_user
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'password', # Assuming you have a default password
    photo_path: Faker::Avatar.image,
    active_status: User.active_statuses.keys.sample,
    created_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now),
    dynamic_link: Faker::Internet.url
  )
end

def generate_post(user)
  Post.create!(
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraphs(number: 3).join("\n"),
    active_status: Post.active_statuses.keys.sample,
    user_id: user.id,
    created_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now)
  )
end

def generate_device(user)
  push_token = generate_unique_push_token
  Device.create!(
    user: user,
    identifier: Device.identifiers.keys.sample,
    push_token: push_token,
    arn: Faker::Lorem.word,
    os: Faker::Device.platform,
    model: Faker::Device.model_name,
    app: Faker::App.name,
    created_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now)
  )
end

def generate_unique_push_token
  loop do
    push_token = Faker::Alphanumeric.alpha(number: 10)
    return push_token unless Device.exists?(push_token: push_token)
  end
end



def generate_access_key(user)
  AccessKey.create!(
    key_id: Faker::Lorem.characters(number: 20),
    secret_key: Faker::Lorem.characters(number: 40),
    active: Faker::Boolean.boolean,
    user_id: user.id,
    created_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Time.zone.now)
  )
end

available_roles = ["admin", "user"]

10.times do
  user = generate_user
  generate_post(user)
  generate_device(user)
  generate_access_key(user)

  user.add_role available_roles.sample
  user.update(confirmed_at: Time.zone.now)
end


#Assuming having a model named `Dashboarddata` associated with the dashboard_data table
10.times do
  Dashboarddata.create(
    compliant_count: rand(0..1000),
    expired_insurance_count: rand(0..1000),
    expiring_insurance_count: rand(0..1000),
    in_default_count: rand(0..1000),
    no_coverage_count: rand(0..1000),
    non_compliant_count: rand(0..1000),
    pending_review_count: rand(0..1000),
    total_deficient_requirements_count: rand(0..100),
    month_1_compliance_rate: rand(0.0..1.0).round(2),
    month_2_compliance_rate: rand(0.0..1.0).round(2),
    month_3_compliance_rate: rand(0.0..1.0).round(2),
    month_4_compliance_rate: rand(0.0..1.0).round(2),
    month_5_compliance_rate: rand(0.0..1.0).round(2),
    month_6_compliance_rate: rand(0.0..1.0).round(2),
    compliant_parties_count: rand(0..100),
    non_compliant_parties_count: rand(0..1000),
    party_month_1_compliance_rate: rand(0.0..1.0).round(2),
    party_month_2_compliance_rate: rand(0.0..1.0).round(2),
    party_month_3_compliance_rate: rand(0.0..1.0).round(2),
    party_month_4_compliance_rate: rand(0.0..1.0).round(2),
    party_month_5_compliance_rate: rand(0.0..1.0).round(2),
    party_month_6_compliance_rate: rand(0.0..1.0).round(2),
    compliant_coverages_count: rand(0..1000),
    total_coverages_count: rand(0..1000),
    coverage_month_1_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_2_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_3_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_4_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_5_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_6_compliance_rate: rand(0.0..1.0).round(2),
    expired_parties_count: rand(0..1000),
    expiring_parties_count: rand(0..1000),
    in_default_parties_count: rand(0..1000),
    pending_review_parties_count: rand(0..1000),
    parties_with_days_in_status_over_a_month: rand(0..1000),
    expired_parties_over_ninety_days: rand(0..1000),
    expiring_parties_over_ninety_days: rand(0..1000),
    parties_defaulted_last_ninety_days: rand(0..1000),
    non_compliant_coverages_count: rand(0..1000),
    no_coverage_coverages_count: rand(0..1000),
    expired_coverages_count: rand(0..1000),
    expiring_coverages_count: rand(0..1000),
    no_coverage_over_ninety_days_count: rand(0..1000),
    expired_coverage_over_ninety_days_count: rand(0..1000),
    current_non_compliant_over_ninety_days_count: rand(0..1000)
  )
end



users = User.limit(5)
parties = Party.limit(5)

start_date = Date.today - 3.months
end_date = Date.today + 1.month


(start_date..end_date).each do |date|
    Dashboarddata.create(
    compliant_count: rand(0..1000),
    expired_insurance_count: rand(0..1000),
    expiring_insurance_count: rand(0..1000),
    in_default_count: rand(0..1000),
    no_coverage_count: rand(0..1000),
    non_compliant_count: rand(0..1000),
    pending_review_count: rand(0..1000),
    total_deficient_requirements_count: rand(0..100),
    month_1_compliance_rate: rand(0.0..1.0).round(2),
    month_2_compliance_rate: rand(0.0..1.0).round(2),
    month_3_compliance_rate: rand(0.0..1.0).round(2),
    month_4_compliance_rate: rand(0.0..1.0).round(2),
    month_5_compliance_rate: rand(0.0..1.0).round(2),
    month_6_compliance_rate: rand(0.0..1.0).round(2),
    compliant_parties_count: rand(0..100),
    non_compliant_parties_count: rand(0..1000),
    party_month_1_compliance_rate: rand(0.0..1.0).round(2),
    party_month_2_compliance_rate: rand(0.0..1.0).round(2),
    party_month_3_compliance_rate: rand(0.0..1.0).round(2),
    party_month_4_compliance_rate: rand(0.0..1.0).round(2),
    party_month_5_compliance_rate: rand(0.0..1.0).round(2),
    party_month_6_compliance_rate: rand(0.0..1.0).round(2),
    compliant_coverages_count: rand(0..1000),
    total_coverages_count: rand(0..1000),
    coverage_month_1_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_2_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_3_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_4_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_5_compliance_rate: rand(0.0..1.0).round(2),
    coverage_month_6_compliance_rate: rand(0.0..1.0).round(2),
    expired_parties_count: rand(0..1000),
    expiring_parties_count: rand(0..1000),
    in_default_parties_count: rand(0..1000),
    pending_review_parties_count: rand(0..1000),
    parties_with_days_in_status_over_a_month: rand(0..1000),
    expired_parties_over_ninety_days: rand(0..1000),
    expiring_parties_over_ninety_days: rand(0..1000),
    parties_defaulted_last_ninety_days: rand(0..1000),
    non_compliant_coverages_count: rand(0..1000),
    no_coverage_coverages_count: rand(0..1000),
    expired_coverages_count: rand(0..1000),
    expiring_coverages_count: rand(0..1000),
    no_coverage_over_ninety_days_count: rand(0..1000),
    expired_coverage_over_ninety_days_count: rand(0..1000),
    current_non_compliant_over_ninety_days_count: rand(0..1000)
  )
end

(start_date..end_date).each do |date|
  Organization.create!(
    name: Faker::Company.name,
    address_line_1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    postal_code: Faker::Address.zip_code,
    phone: Faker::PhoneNumber.phone_number,
    contact_name: Faker::Name.name,
    email: Faker::Internet.email,
    country: Faker::Address.country,
    slug: Faker::Internet.slug,
    time_zone: Faker::Address.time_zone,
    created_at: created_at,
    updated_at: created_at + rand(1..7).days # Update within a week of creation
  )
end


(start_date..end_date).each do |date|
   uid = SecureRandom.hex(8)
  Agreement.create(
    party_id: parties.sample.id,
    created_at: Faker::Time.backward(days: 6),
    updated_at: Faker::Time.backward(days: 7),
    deleted_at: [nil, Faker::Time.backward(days: 5)].sample, # 50% chance of being nil
    name: Faker::Lorem.words(number: 3).join(' '),
    starts_on: Faker::Date.backward(days: 300),
    ends_on: Faker::Date.forward(days: 300),
    agreement_type: rand(0..5), # Assuming there are up to 5 types. Adjust accordingly.
    agreement_status: rand(0..5), # Assuming there are up to 5 statuses. Adjust accordingly.
    uid: uid,
    description: Faker::Lorem.paragraph,
    compliance_processed: [true, false].sample,
    defaulted_at: [nil, Faker::Time.backward(days: 20)].sample, # 50% chance of being nil
    requirement_set_applied_at: [nil, Faker::Time.backward(days: 15)].sample, # 50% chance of being nil
    user_id: users.sample.id,
    status:  ['no coverage', 'compliant', 'non-compliant', 'waived'].sample,
    last_compliance_update: Faker::Time.backward(days: 30)
  )
end

(start_date..end_date).each do |date|
  Party.create!(
    name: Faker::Company.name,
    address_line_1: Faker::Address.street_address,
    address_line_2: Faker::Address.secondary_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    status: ['no coverage', 'compliant', 'non-compliant', 'waived'].sample,
    postal_code: Faker::Address.zip_code,
    phone: Faker::PhoneNumber.phone_number,
    fax: Faker::PhoneNumber.phone_number,
    country: Faker::Address.country,
    uid: SecureRandom.uuid,
    slug: SecureRandom.hex(10),
    user_id: users.sample.id, # Assumes you have a User model with an id column
    created_at: date,
    updated_at: date
  )
end

# users = User.limit(5)
# parties = Party.limit(5)

# 20.times do
#   uid = SecureRandom.hex(8)
#   Agreement.create(
#     party_id: parties.sample.id,
#     created_at: Faker::Time.backward(days: 6),
#     updated_at: Faker::Time.backward(days: 7),
#     deleted_at: [nil, Faker::Time.backward(days: 5)].sample, # 50% chance of being nil
#     name: Faker::Lorem.words(number: 3).join(' '),
#     starts_on: Faker::Date.backward(days: 300),
#     ends_on: Faker::Date.forward(days: 300),
#     agreement_type: rand(0..5), # Assuming there are up to 5 types. Adjust accordingly.
#     agreement_status: rand(0..5), # Assuming there are up to 5 statuses. Adjust accordingly.
#     uid: uid,
#     description: Faker::Lorem.paragraph,
#     compliance_processed: [true, false].sample,
#     defaulted_at: [nil, Faker::Time.backward(days: 20)].sample, # 50% chance of being nil
#     requirement_set_applied_at: [nil, Faker::Time.backward(days: 15)].sample, # 50% chance of being nil
#     user_id: users.sample.id,
#     status:  ['no coverage', 'compliant', 'non-compliant', 'waived'].sample,
#     last_compliance_update: Faker::Time.backward(days: 30)
#   )
# end


