set[:rbenv][:dir]             = "/usr/local/rbenv"
set[:rbenv][:repository]      = "git://github.com/sstephenson/rbenv.git"
default[:rbenv][:version]     = "v0.3.0"
default[:rbenv][:action]      = "install" # anything else will remove rbenv from the system
default[:rbenv][:global_ruby] = false
default[:rbenv][:global_gems] = %w[bundler pry foreman]

set[:ruby_build][:dir]         = "/usr/local/ruby-build"
set[:ruby_build][:install_dir] = "/usr/local/rbenv/versions"
set[:ruby_build][:keep_dir]    = "/usr/local/src/ruby-build"
set[:ruby_build][:repository]  = "git://github.com/sstephenson/ruby-build.git"
default[:ruby_build][:version] = "v20120815"
default[:ruby_build][:action]  = "install" # anything else will remove ruby-build from the system
default[:ruby_build][:rubies]  = []
