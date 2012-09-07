action :create do
  manage_rbenv_user_profile
end

action :delete do
  manage_rbenv_user_profile
end

#################################################################### IMPLEMENTATION #

def manage_rbenv_user_profile
  if node.has_key?(:bootstrap)
    bootstrap_profile "rbenv" do
      username new_resource.name
      params rbenv_params
      action new_resource.action
    end
  else
    Chef::Log.error("https://github.com/gchef/bootstrap-cookbook is not available, you will need to configure rbenv manually for #{new_resource.name}'s shell environment")
  end
end

def rbenv_params
  rbenv_params = [%{export RBENV_ROOT="#{node[:rbenv][:dir]}"}]
  rbenv_profile_path = %w[$RBENV_ROOT/shims $RBENV_ROOT/bin] # yay, no rbenv init!
  # I had the ruby-build binaries here initially, but having
  # different users install rubies (EVEN IF THEY ARE ADMINS) can
  # create a lot of permission-related issues
  rbenv_profile_path << "$PATH"
  rbenv_params << %{export PATH="#{rbenv_profile_path.join(':')}"}
end
