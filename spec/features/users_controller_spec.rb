# require "rails_helper"

# feature "User management", type: :feature do
#   scenario "Updates user first name and last name" do
#     admin = create(:user, role: :superadmin, first_name: 'Dev', last_name: 'Admin')
#     visit root_path
#     fill_in 'user_email', with: admin.email
#     fill_in 'user_password', with: admin.password
#     click_button 'Sign in'

#     expect(current_path).to eq superadmin_bookings_path

#     #navigate to user edit profile page
#     visit edit_superadmin_user_path(admin)

#     fill_in 'user_first_name', with: 'Bitcot'
#     fill_in 'user_last_name', with: 'Dev'

#     click_button 'submit'

#     # TODO
#     # nav_dropdown_button_text = find('.dropdown-toggle').text
#     # expect(nav_dropdown_button_text).to eq('Bitcot Dev')
#   end
# end