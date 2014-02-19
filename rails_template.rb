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
@path = '/a/fearoffish/rails-template/files/'
## Gems
gsub_file 'Gemfile', /gem 'sqlite3'/, ''

gem 'pg'
gem 'foundation-rails'
gem 'simple_form'

gem 'devise'
gem 'devise_cas_authenticatable'
gem 'cancan'

gem 'high_voltage'

gem 'haml-rails'

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
copy_file @path + 'spec/spec_helper.rb', 'spec/spec_helper.rb'

remove_file 'Guardfile'
copy_file @path + 'Guardfile', 'Guardfile'

# Haml views
# copy_file @path + 'lib/templates/haml/scaffold/_form.html.haml', 'lib/templates/haml/scaffold/_form.html.haml'
copy_file @path + 'lib/templates/haml/scaffold/edit.html.haml', 'lib/templates/haml/scaffold/edit.html.haml'
copy_file @path + 'lib/templates/haml/scaffold/index.html.haml', 'lib/templates/haml/scaffold/index.html.haml'
copy_file @path + 'lib/templates/haml/scaffold/new.html.haml', 'lib/templates/haml/scaffold/new.html.haml'
copy_file @path + 'lib/templates/haml/scaffold/show.html.haml', 'lib/templates/haml/scaffold/show.html.haml'

# rake
copy_file @path + 'lib/tasks/dev.rake', 'lib/tasks/dev.rake'

# Application Layout
remove_file 'app/views/layouts/application.html.erb'
copy_file @path + 'app/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'

remove_file 'app/assets/javascripts/application.js'
copy_file @path + 'app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
copy_file @path + 'app/assets/javascripts/modernizr.js', 'app/assets/javascripts/modernizr.js'
copy_file @path + 'app/assets/stylesheets/print/custom-print.css.scss', 'app/assets/stylesheets/print/custom-print.css.scss'
copy_file @path + 'app/assets/stylesheets/print/framework_and_overrides.css.scss', 'app/assets/stylesheets/print/framework_and_overrides.css.scss'
copy_file @path + 'app/assets/stylesheets/screen/custom-screen.css.scss', 'app/assets/stylesheets/screen/custom-screen.css.scss'
copy_file @path + 'app/assets/stylesheets/screen/framework_and_overrides.css.scss', 'app/assets/stylesheets/screen/framework_and_overrides.css.scss'
copy_file @path + 'app/assets/stylesheets/application.css.scss', 'app/assets/stylesheets/application.css.scss'
copy_file @path + 'app/assets/stylesheets/print.css.scss', 'app/assets/stylesheets/print.css.scss'

copy_file @path + 'app/views/layouts/_messages.html.haml', 'app/views/layouts/_messages.html.haml'
copy_file @path + 'app/views/layouts/_navigation.html.haml', 'app/views/layouts/_navigation.html.haml'
copy_file @path + 'app/views/layouts/_navigation_links.html.haml', 'app/views/layouts/_navigation_links.html.haml'
copy_file @path + 'app/views/layouts/_user_links.html.haml', 'app/views/layouts/_user_links.html.haml'

# SimpleForm
generate 'simple_form:install --foundation'

# Devise
generate 'devise:install'
copy_file @path + 'app/controllers/devise/confirmations_controller.rb', 'app/controllers/devise/confirmations_controller.rb'
gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
generate 'devise User'

gsub_file 'config/routes.rb', /  devise_for :users/ do <<-RUBY
  devise_for :users
RUBY
end

# admin.rb, user.rb
remove_file 'app/models/user.rb'
copy_file @path + 'app/models/user.rb', 'app/models/user.rb'

rake 'db:migrate'

# Role Table
generate 'model role name:string'

# CanCan
generate 'cancan:ability'

# CAS Authenticate
inject_into_file 'config/initializers/devise.rb', :before => "\nend" do <<-RUBY
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

copy_file @path + 'config/locales/i18n/pluralization.rb', 'config/locales/i18n/pluralization.rb'
copy_file @path + 'config/locales/active_model.en.yml', 'config/locales/active_model.en.yml'
copy_file @path + 'config/locales/active_model.tr.yml', 'config/locales/active_model.tr.yml'
copy_file @path + 'config/locales/active_record.en.yml', 'config/locales/active_record.en.yml'
copy_file @path + 'config/locales/active_record.tr.yml', 'config/locales/active_record.tr.yml'
copy_file @path + 'config/locales/default.en.yml', 'config/locales/default.en.yml'
copy_file @path + 'config/locales/default.tr.yml', 'config/locales/default.tr.yml'
copy_file @path + 'config/locales/devise.tr.yml', 'config/locales/devise.tr.yml'
copy_file @path + 'config/locales/devise.en.yml', 'config/locales/devise.en.yml'
copy_file @path + 'config/locales/en.yml', 'config/locales/en.yml'
copy_file @path + 'config/locales/tr.yml', 'config/locales/tr.yml'
copy_file @path + 'config/locales/helpers.en.yml', 'config/locales/helpers.en.yml'
copy_file @path + 'config/locales/helpers.tr.yml', 'config/locales/helpers.tr.yml'
copy_file @path + 'config/locales/mails.tr.yml', 'config/locales/mails.tr.yml'
copy_file @path + 'config/locales/mails.en.yml', 'config/locales/mails.en.yml'
copy_file @path + 'config/locales/models.en.yml', 'config/locales/models.en.yml'
copy_file @path + 'config/locales/models.tr.yml', 'config/locales/models.tr.yml'
copy_file @path + 'config/locales/nav.tr.yml', 'config/locales/nav.tr.yml'
copy_file @path + 'config/locales/nav.en.yml', 'config/locales/nav.en.yml'
copy_file @path + 'config/locales/pages.en.yml', 'config/locales/pages.en.yml'
copy_file @path + 'config/locales/pages.tr.yml', 'config/locales/pages.tr.yml'
copy_file @path + 'config/locales/responders.tr.yml', 'config/locales/responders.tr.yml'
copy_file @path + 'config/locales/responders.en.yml', 'config/locales/responders.en.yml'
copy_file @path + 'config/locales/show_for.en.yml', 'config/locales/show_for.en.yml'
copy_file @path + 'config/locales/show_for.tr.yml', 'config/locales/show_for.tr.yml'
copy_file @path + 'config/locales/simple_form.tr.yml', 'config/locales/simple_for.tr.yml'
copy_file @path + 'config/locales/simple_form.en.yml', 'config/locales/simple_for.en.yml'
copy_file @path + 'config/locales/title.en.yml', 'config/locales/title.en.yml'
copy_file @path + 'config/locales/title.tr.yml', 'config/locales/title.tr.yml'
copy_file @path + 'config/locales/validates_timeliness.tr.yml', 'config/locales/validates_timeliness.tr.yml'

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
copy_file @path + 'app/views/layouts/email.html.haml', 'app/views/layouts/email.html.haml'

# Controller
remove_file 'app/controllers/application_controller.rb'
copy_file @path + 'app/controllers/application_controller.rb', 'app/controllers/application_controller.rb'

# High Voltage
create_file 'config/initializers/high_voltage.rb' do <<-RUBY
HighVoltage.configure do |config|
  config.home_page = 'home'
  config.route_drawer = HighVoltage::RouteDrawers::Root
end

RUBY
end
copy_file @path + 'app/views/pages/home.html.haml', 'app/views/pages/home.html.haml'

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

# Change Application Name
gsub_file 'app/views/layouts/application.html.haml', /Change Me/, "#{app_name.humanize.titleize}"

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
copy_file @path + 'README.md', 'README.md'

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