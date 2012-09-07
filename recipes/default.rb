install = (node[:rbenv][:action] == "install")

if defined?(Chef::Extensions)
  wan_up = Chef::Extensions.wan_up?
else
  # Should be part of Chef really...
  # grab it here https://github.com/gchef/chef-extensions
  wan_up = "unknown"
end

if install
  git node[:rbenv][:dir] do
    repository node[:rbenv][:repository]
    reference node[:rbenv][:version]
    action :sync
    only_if { wan_up }
  end

  directory "#{node[:rbenv][:dir]}/versions"
  directory "#{node[:rbenv][:dir]}/shims"

  # If you declare a global ruby, it will be automatically added to rubies
  # and set as the default ruby
  if node[:rbenv][:global_ruby]
    node[:ruby_build][:rubies] << node[:rbenv][:global_ruby]

    file "#{node[:rbenv][:dir]}/version" do
      content node[:rbenv][:global_ruby]
    end
  end

  if node[:ruby_build][:rubies].any? and wan_up
    # Builds all rubies, system-wide
    require_recipe "rbenv::ruby_build" 

    # rehash so that shims will get created
    execute "#{node[:rbenv][:dir]} #{node[:rbenv][:dir]}/bin/rbenv rehash; exit 0"

    bash "Installing global gems" do
      code %{
        export PATH=#{node[:rbenv][:dir]}/shims:#{node[:rbenv][:dir]}/bin:$PATH
        gem update #{node[:rbenv][:global_gems].join(' ')}
      }
    end

    # rehash again so that gem executables get set up correctly
    execute "RBENV_ROOT=#{node[:rbenv][:dir]} #{node[:rbenv][:dir]}/bin/rbenv rehash; exit 0"
  end
else
  directory node[:rbenv][:dir] do
    recursive true
    action :delete
  end
end

# Set up all users part of the ruby system group with rbenv
node.fetch("system_users") { [] }.each do |system_user, system_user_properties|
  if system_user_properties.fetch(:groups) { [] }.include?("rbenv")
    rbenv_user system_user do
      action (install ? :create : :delete)
    end
  end
end

if install
  # just in case bootstrap-cookbook is not available...
  group "rbenv"

  execute "chmod -fR 755 #{node[:rbenv][:dir]}"
  execute "chown -fR root.rbenv #{node[:rbenv][:dir]}"
end
