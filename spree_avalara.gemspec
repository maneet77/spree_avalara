# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_avalara'
  s.version     = '0.0.3'
  s.summary     = "Spree exteion to use Avalara's AvaTax REST API to calculate and store sales tax charges"
  s.description = "Spree_avalara uses the avalara gem to communicate with the AvaTax API.  An Avalara (trial or real) account is needed. Straightforward configuration."
  s.required_ruby_version = '>= 1.9.2'

  s.author    = 'Eric Winter'
  s.email     = 'eric@railsdog.com'
  s.homepage  = 'http://railsdog.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.3.2'
  s.add_dependency 'avalara', '~> 0.0.3'

  s.add_development_dependency 'capybara', '~> 1.1.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end
