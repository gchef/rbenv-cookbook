install = (node[:ruby_build][:action] == "install")

directory node[:ruby_build][:keep_dir] do
  action (install ? :create : :delete)
end

if defined?(Chef::Extensions)
  wan_up = Chef::Extensions.wan_up?
else
  # Should be part of Chef really...
  # grab it here https://github.com/gchef/chef-extensions
  wan_up = "unknown"
end

if install
  git node[:ruby_build][:dir] do
    repository node[:ruby_build][:repository]
    reference node[:ruby_build][:version]
    action :sync
    only_if { wan_up }
  end

  directory node[:ruby_build][:install_dir]

  node[:ruby_build][:rubies].each do |ruby_version|
    bash "Installing Ruby #{ruby_version}" do
      code %{
        if [[ ! $(ls #{node[:ruby_build][:install_dir]}) =~ #{ruby_version} ]]
        then
          export RUBY_BUILD_BUILD_PATH=#{node[:ruby_build][:keep_dir]}
          #{node[:ruby_build][:dir]}/bin/ruby-build --keep #{ruby_version} #{node[:ruby_build][:install_dir]}/#{ruby_version}
        fi
      }
      only_if { wan_up }
    end
  end
else
  directory node[:ruby_build][:dir] do
    recursive true
    action :delete
  end
end
