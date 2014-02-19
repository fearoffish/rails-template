##
# Application Generator Template
# Usage: rails new APP_NAME  -T -m https://raw.github.com/lab2023/rails-template/master/rails_template.rb
#
# If you are customizing this template, you can use any methods provided by Thor::Actions
# http://rubydoc.info/github/wycats/thor/master/Thor/Actions
# and Rails::Generators::Actions
# http://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb

require 'securerandom'

@path = 'https://raw.github.com/fearoffish/rails-template/master/files/'

## Gems
gsub_file 'Gemfile', /gem 'sqlite3'/, ''

gem 'pg'
gem 'foundation-rails'
gem 'simple_form'

gem 'devise'
gem 'devise_cas_authenticatable'

gem_group :development do
  gem 'rails_layout'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem "factory_girl_rails", "~> 4.0"
end

# Bundle
run 'bundle install'

# Database config
remove_file 'config/database.yml'
create_file 'config/database.yml' do <<-RUBY
development:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_development
  pool: 5
  username: jamievandyke
  password:

test:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_test
  pool: 5
  username: jamievandyke
  password:

RUBY
end

# Database
rake 'db:drop:all'
rake 'db:create:all'
run 'rails g rspec:install'
run 'mkdir spec/support spec/models spec/routing'
run 'bundle exec guard init spec'

# Spec
remove_file 'spec/spec_helper.rb'
get @path + 'spec/spec_helper.rb', 'spec/spec_helper.rb'

remove_file 'Guardfile'
get @path + 'Guardfile', 'Guardfile'

# Haml views
get @path + 'lib/templates/haml/scaffold/_form.html.haml', 'lib/templates/haml/scaffold/_form.html.haml'
get @path + 'lib/templates/haml/scaffold/edit.html.haml', 'lib/templates/haml/scaffold/edit.html.haml'
get @path + 'lib/templates/haml/scaffold/index.html.haml', 'lib/templates/haml/scaffold/index.html.haml'
get @path + 'lib/templates/haml/scaffold/new.html.haml', 'lib/templates/haml/scaffold/new.html.haml'
get @path + 'lib/templates/haml/scaffold/show.html.haml', 'lib/templates/haml/scaffold/show.html.haml'

# rake
get @path + 'lib/tasks/dev.rake', 'lib/tasks/dev.rake'

# Application Layout
remove_file 'app/views/layouts/application.html.erb'
get @path + 'app/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'

remove_file 'app/assets/javascripts/application.js'
get @path + 'app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
get @path + 'app/assets/stylesheets/application.css.scss', 'app/assets/stylesheets/application.css.scss'

# SimpleForm
generate 'simple_form:install --foundation'

# Devise
generate 'devise:install'
get @path + 'app/controllers/devise/confirmations_controller.rb', 'app/controllers/devise/confirmations_controller.rb'
gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
generate 'devise User'

gsub_file 'config/routes.rb', /  devise_for :users/ do <<-RUBY
  devise_for :users
RUBY
end

gsub_file 'config/initializers/devise.rb', /\nend/ do <<-RUBY
  ## CAS Authentication
  config.cas_base_url = ENV['CASINOAPP_URL'] || "http://casinoapp.dev"
  config.cas_username_column = "email"
  config.cas_logout_url_param = "destination"
  config.cas_destination_logout_param_name = "service"
  config.cas_create_user = true

  config.warden do |manager|
    manager.failure_app = DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp
  end
end
RUBY
end

# admin.rb, user.rb
remove_file 'app/models/user.rb'
get @path + 'app/models/user.rb', 'app/models/user.rb'

rake 'db:migrate'

# Role Table
generate 'model role name:string'

# CanCan
generate 'cancan:ability'

# CAS Authenticate
inject_into_file 'config/devise.rb', :before => 'end' do <<-RUBY
  config.cas_base_url = ENV['CAS_URL'] || "http://casinoapp.dev"
  config.cas_username_column = "email"
  config.cas_logout_url_param = "destination"
  config.cas_destination_logout_param_name = "service"
  config.cas_create_user = true

  config.warden do |manager|
    manager.failure_app = DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp
  end

RUBY
end

# Locale Settings
inject_into_file 'config/application.rb', :after => 'class Application < Rails::Application' do <<-RUBY


    config.time_zone = 'UTC'
    config.i18n.default_locale = :en


RUBY
end

remove_file "config/locales/devise.en.yml"
remove_file "config/locales/en.yml"
remove_file "config/locales/responder.en.yml"
remove_file "config/locales/responders.en.yml"
remove_file "config/locales/show_for.en.yml"

get @path + 'config/locales/i18n/pluralization.rb', 'config/locales/i18n/pluralization.rb'
get @path + 'config/locales/active_model.en.yml', 'config/locales/active_model.en.yml'
get @path + 'config/locales/active_model.tr.yml', 'config/locales/active_model.tr.yml'
get @path + 'config/locales/active_record.en.yml', 'config/locales/active_record.en.yml'
get @path + 'config/locales/active_record.tr.yml', 'config/locales/active_record.tr.yml'
get @path + 'config/locales/default.en.yml', 'config/locales/default.en.yml'
get @path + 'config/locales/default.tr.yml', 'config/locales/default.tr.yml'
get @path + 'config/locales/devise.tr.yml', 'config/locales/devise.tr.yml'
get @path + 'config/locales/devise.en.yml', 'config/locales/devise.en.yml'
get @path + 'config/locales/en.yml', 'config/locales/en.yml'
get @path + 'config/locales/tr.yml', 'config/locales/tr.yml'
get @path + 'config/locales/helpers.en.yml', 'config/locales/helpers.en.yml'
get @path + 'config/locales/helpers.tr.yml', 'config/locales/helpers.tr.yml'
get @path + 'config/locales/mails.tr.yml', 'config/locales/mails.tr.yml'
get @path + 'config/locales/mails.en.yml', 'config/locales/mails.en.yml'
get @path + 'config/locales/models.en.yml', 'config/locales/models.en.yml'
get @path + 'config/locales/models.tr.yml', 'config/locales/models.tr.yml'
get @path + 'config/locales/nav.tr.yml', 'config/locales/nav.tr.yml'
get @path + 'config/locales/nav.en.yml', 'config/locales/nav.en.yml'
get @path + 'config/locales/pages.en.yml', 'config/locales/pages.en.yml'
get @path + 'config/locales/pages.tr.yml', 'config/locales/pages.tr.yml'
get @path + 'config/locales/responders.tr.yml', 'config/locales/responders.tr.yml'
get @path + 'config/locales/responders.en.yml', 'config/locales/responders.en.yml'
get @path + 'config/locales/show_for.en.yml', 'config/locales/show_for.en.yml'
get @path + 'config/locales/show_for.tr.yml', 'config/locales/show_for.tr.yml'
get @path + 'config/locales/simple_form.tr.yml', 'config/locales/simple_for.tr.yml'
get @path + 'config/locales/simple_form.en.yml', 'config/locales/simple_for.en.yml'
get @path + 'config/locales/title.en.yml', 'config/locales/title.en.yml'
get @path + 'config/locales/title.tr.yml', 'config/locales/title.tr.yml'
get @path + 'config/locales/validates_timeliness.tr.yml', 'config/locales/validates_timeliness.tr.yml'

# Mail Settings
inject_into_file 'config/environments/development.rb', :after => 'config.assets.debug = true' do <<-RUBY

  # Mail Settings
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
RUBY
end

inject_into_file 'config/environments/production.rb', :after => 'config.active_support.deprecation = :notify' do <<-RUBY

  # Mail Settings
  config.action_mailer.default_url_options = { :host => 'viverehealth.com' }

RUBY
end

# Email layout
get @path + 'app/views/layouts/email.html.haml', 'app/views/layouts/email.html.haml'

# Controller
remove_file 'app/controllers/application_controller.rb'
get @path + 'app/controllers/application_controller.rb', 'app/controllers/application_controller.rb'

# Title Helper
inject_into_file 'app/helpers/application_helper.rb', :before => 'end' do <<-RUBY
  def title(page_title)
    content_for(:title) { page_title }
  end
RUBY
end

# Clean-up
%w{
  README
  doc/README_FOR_APP
  public/index.html
  app/assets/images/rails.png
}.each { |file| remove_file file }

#Change Application Name
gsub_file 'app/views/layouts/application.html.haml', /Change Me/, "#{app_name.humanize.titleize}"
gsub_file 'app/views/layouts/admins/application.html.haml', /Change Me/, "#{app_name.humanize.titleize}"

# Git
append_file '.gitignore' do <<-GIT
/public/system
/public/uploads
/coverage
rerun.txt
.rspec
capybara-*.html
.DS_Store
.rbenv-vars
.rbenv-version
.bundle
db/*.sqlite3
db/database.yml
log/*.log
log/*.pid
.sass-cache/
tmp/**/*
.rvmrc
.DS_Store
db-dumps
**/.DS_Store
nbproject/**/*
.yardoc/**/*
.yardoc
nbproject
.idea
.idea/**/*
GIT
end

# README.md
get @path + 'README.md', 'README.md'

remove_file 'app/assets/stylesheets/application.css'
rake 'db:migrate'
rake 'dev:setup'

gsub_file 'config/initializers/devise.rb', /config.secret_key = .*/, "config.secret_key = ENV['DEVISE_SECRET']"
gsub_file 'config/initializers/devise.rb', /'please-change-me-at-config-initializers-devise@example.com'/, "config.mailer_sender = ENV['DEVISE_MAIL_SENDER']"

# ENV config
key = SecureRandom.hex(128)
create_file '.envrc' do <<-RUBY
export DEVISE_SECRET=#{key}
export DEVISE_MAIL_SENDER='info@viverehealth.com'
export CAS_URL='http://casinoapp.dev'
RUBY
end

git :init
git :add => '.'
git :commit => '-m "close #1 Install Rails "'