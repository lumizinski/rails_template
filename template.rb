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

def add_navbar
  navbar = 'app/views/layouts/_navbar.html.erb'
  FileUtils.touch(navbar)
  inject_into_file 'app/views/layouts/application.html.erb', before: '<%= yield %>' do
    "\n<%= render 'layouts/navbar' %>\n"
  end
  append_to_file navbar do
    '<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <%= link_to "Rails.application.class.parent_name", root_path, class:"navbar-brand"%>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <%= link_to "Home", root_path, class:"nav-link" %>
            </li>
            <li class="nav-item">
                <%= link_to "Blog", articles_path, class:"nav-link" %>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <% if current_user %>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <%= current_user.username %>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                    <%= link_to "Account Settings", edit_user_registration_path, class:"dropdown-item" %>
                    <div class="dropdown-divider"></div>
                    <%= link_to "Logout", destroy_user_session_path, method: :delete, class:"dropdown-item" %>
                </div>
            </li>
            <% else %>
            <li class="nav-item">
                <%= link_to "Create An Account", new_user_registration_path, class:"nav-link" %>
            </li>
            <li class="nav-item">
                <%= link_to "Login", new_user_session_path, class:"nav-link" %>
            </li>
            <% end %>
        </ul>
    </div>
    </nav>'
  end
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
add_navbar

generate(:scaffold, "article", "title:string")

