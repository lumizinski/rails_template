# rails new blog -m ~/template.rb


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

generate(:scaffold, "article", "title:string")
