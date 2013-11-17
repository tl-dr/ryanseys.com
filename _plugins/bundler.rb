require "rubygems"
require "bundler/setup"
Bundler.require(:default)
puts 'Set encoding to UTF8'
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
if RUBY_VERSION =~ /1.9/
     Encoding.default_external = Encoding::UTF_8
     Encoding.default_internal = Encoding::UTF_8
end
