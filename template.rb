# rails new blog -m ./template.rb


def add_gem(name, *options)
  gem(name, *options) unless gem_exists?(name)
end

def add_devise
  add_gem 'devise'
  generate 'devise:install'
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000}",
              env: 'development'
  generate :devise, 'User', 'username:string:uniq', 'admin:boolean'
end

def add_home
  generate(:controller, "home", "index", "blog", "contact")
  route "root to: 'home#index'"
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
add_devise
add_tests

generate(:scaffold, "article", "title:string")

