# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "fast_update/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "fast_update"
  spec.version     = FastUpdate::VERSION
  spec.authors     = ["Tiffany Chan "]
  spec.email       = ["tjychan@uvic.ca"]
  spec.homepage    = "https://github.com/UVicLibrary/fast_update"
  spec.summary     = "Automatic FAST reconciliation for Hyrax(-based) repositories"
  spec.description = "Tools for automatically updating newly-created or modified OCLC FAST (https://www.oclc.org/research/areas/data-science/fast.html) subject headings and replacing/deleting OCLC FAST URIs."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2"
  spec.add_dependency "hyrax", ">= 3.0", "< 3.2"
  spec.add_dependency "simple_xlsx_reader"
  spec.add_development_dependency 'database_cleaner', '~> 1.3'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency 'webdrivers', '~> 4.4'
  spec.add_development_dependency 'webmock'
end
