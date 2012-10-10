install = (node[:ruby_build][:action] == "install")
wan_up = `ping -c 1 -W 1 8.8.8.8`.index(/1 (?:packets )?received/)

directory node[:ruby_build][:keep_dir] do
  action (install ? :create : :delete)
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
          #{node[:ruby_build][:dir]}/bin/ruby-build --keep #{ruby_version} #{node[:ruby_build][:install_dir]}/#{ruby_version} --with-openssl-dir=/usr
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
