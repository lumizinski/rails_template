# rails new blog -j esbuild --css bootstrap -m ./template.rb
# rails new blog -d postgresql -T --edge --css tailwind -m ./template.rb


def add_gem(name, *options)
  gem(name, *options) unless gem_exists?(name)
end

def add_login
  add_gem 'devise'
  add_gem 'cancancan'
  run "bundle install"
  generate 'devise:install'
  generate 'cancan:ability'
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000}",
              env: 'development'
  generate :devise, 'User', 'username:string:uniq', 'admin:boolean'
end

def add_home
  generate(:controller, "home", "index", "blog", "contact")
  route "root to: 'home#index'"
end

def add_rails_admin
  add_gem 'rails_admin', '~> 3.0'
  run "bundle install"
  generate "rails_admin:install"
end

def add_tests
  gem_group :development, :test do
    add_gem "rspec-rails"
    add_gem "factory_bot_rails"
    add_gem 'faker'
  end
  run "bundle install"
  generate 'rspec:install'
end

def gem_exists?(name)
  IO.read("Gemfile") =~ /ˆ\s*gem ['"]#{name}['"]/
end

add_home
add_login
add_tests
add_rails_admin

generate(:scaffold, "article", "title:string")

