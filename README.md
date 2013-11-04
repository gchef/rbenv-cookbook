Get familiar with [rbenv][1] &amp; [ruby-build][2].

rvm is cool, but rbenv & ruby-build are cooler.  They work really well in
development and, most importantly, they're simple.  **Simple is good**. 
If you insist on using rvm, [here's the chef cookbook][3].

This cookbook sets up rbenv and ruby-build system-wide. It won't allow
users to install rubies or gems. This is intentional. There's bundler,
all apps should come packaged with all dependencies and installed from
`vendor/cache`. If you listen and don't go against those conventions
you'll save yourself a lot of unnecessary hassle.

System gems are controlled via `node[:rbenv][:global_gems]`, they will
be kept updated across all rubies installed via
`node[:ruby_build][:rubies]`.

The cookbook cleanly separates rbenv from ruby-build, you can have one
without the other. It also knows how to cleanup, just pass `:action =>
"anything-but-install"` to either `node[:rbenv]` or `node[:ruby_build]`.

I'm sticking to the lastest stable versions, but since I'm setting both
of them from git repositories, feel free to overwrite this (it can be
any git reference).

If you'll include [bootstrap][4] into your cookbooks, all
`:system_users` that belong to the **rbenv** group will get rbenv setup
in their user profile for free.  Check [`bootstrap_profile` provider][5]
for implementation details.

[1]: https://github.com/sstephenson/rbenv
[2]: https://github.com/sstephenson/ruby-build
[3]: https://github.com/gchef/rvm-cookbook
[4]: https://github.com/gchef/bootstrap-cookbook
[5]: https://github.com/gchef/bootstrap-cookbook/blob/master/providers/profile.rb
