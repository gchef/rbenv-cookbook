actions :create, :delete

attribute :home_basepath,  :kind_of => String,  :default => "/home"
attribute :rubies,         :kind_of => Array,   :default => []
# some users might have a different global ruby
attribute :global_ruby

def initialize(*args)
  super
  @action = :create
end

def rbenv_path
  return @rbenv_path if @rbenv_path
  @rbenv_path = "#{home_basepath}/#{name}/.rbenv"
end
