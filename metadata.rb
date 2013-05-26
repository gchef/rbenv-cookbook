maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures latest stable rbenv and ruby-build"
version           "0.2.1"

recipe "rbenv::default", "Installs both rbenv and ruby-build"
recipe "rbenv::ruby_build", "Installs both rbenv and ruby-build"

supports "ubuntu"
supports "debian" # untested
