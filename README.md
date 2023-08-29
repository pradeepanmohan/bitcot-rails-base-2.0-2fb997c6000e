# README
Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
## Developer Setup

1. Install `ruby 3.2.2` and `rails 7.0.6`
2. Install dependencies for Linux Ubuntu (20.04.6 LTS)
3. `bundle`
4. `rails db:setup` - runs `db:create`, `db:schema:load` and `db:seed`
5. `rails server`
6. Add `127.0.0.1 localtest.me` to `/config/environments/development.rb`
7. Go to http://localtest.me:3000 in a browser
8. Add master.key to your config folder
9. Check credentials using:  EDITOR="vim" rails credentials:edit


### Using Rolify for Role Management

## Define Roles
Open the app/models/role.rb file and customize the available roles as needed. For example:

class Role < ApplicationRecord
enum name: { user: 'user', admin: 'admin' }
end

## Assign Roles

# Find a user (replace 'user_id' with the actual user ID)
user = User.find(user_id)

# Add a role to the user
user.add_role(:admin) => For Admin Role
user.add_role(:user) => For User role

# Remove a role from the user
user.remove_role(:admin)
user.remove_role(:admin)

# Check if the user has a specific role
user.has_role?(:admin)  # returns true or false
user.has_role?(:user)   # returns true or false

To index the data to the elasticsearch using search Kick
Model.reindex

example: Post.reindex
