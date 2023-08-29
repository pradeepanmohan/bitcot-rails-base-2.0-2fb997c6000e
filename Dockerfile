# Use the official Ruby image as a parent image
FROM ruby:3.2.2

# Set environment variables
ENV RAILS_ROOT /var/www/rails_app
ENV RAILS_ENV 'staging'
ENV RACK_ENV 'staging'

# Set working directory
WORKDIR $RAILS_ROOT

# Install dependencies
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install --global yarn

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Install JavaScript packages
COPY package.json yarn.lock ./
RUN yarn install --check-files
RUN yarn add esbuild

# Copy the main application
COPY . ./

# Precompile assets
RUN bundle exec rails assets:precompile

RUN bundle exec rails db:migrate

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-e", "staging"]
