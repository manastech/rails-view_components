$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "view_components/version"

travis = ENV["TRAVIS"] || "false"

rails_version = ENV["RAILS_VERSION"] || "default"
rails = case rails_version
when "default"
  nil
else
  "~> #{rails_version}"
end

include_test_unit = travis == "true" && ENV["TRAVIS_RUBY_VERSION"] != "1.9.3"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "view_components"
  s.version     = ViewComponents::VERSION
  s.authors     = ["Brian J. Cardiff", "Santiago Palladino"]
  s.email       = ["bcardiff@manas.com.ar", "spalladino@manas.com.ar"]
  s.homepage    = "https://github.com/manastech/rails-view_components"
  s.summary     = "Simple library for building view components in Ruby on Rails"
  s.description = "Simple library for building view components in Ruby on Rails. A view component is defined by sections and attributes, and its structure is defined once in a partial view in the `app/views/components` folder, and can be invoked by a simple helper method."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["{test,spec}/**/*"] - Dir["{test,spec}/dummy/tmp/**/*"] - Dir["{test,spec}/dummy/log/**/*"] - Dir["{test,spec}/dummy/db/*.sqlite3"]

  s.add_dependency "rails", rails

  s.add_development_dependency "test-unit" if include_test_unit
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "haml-rails"
end
