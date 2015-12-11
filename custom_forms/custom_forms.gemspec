$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'custom_forms/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'custom_forms'
  s.version     = CustomForms::VERSION
  s.authors     = ['helsayed']
  s.email       = ['hussein.elsayed@badrit.com']
  s.homepage    = ''
  s.summary     = ''
  s.description = ''
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails'
  s.add_dependency 'pg'
  s.add_dependency 'haml-rails'

  s.add_dependency 'audited-activerecord'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'jquery-datatables-rails', '~> 3.3.0'
  s.add_dependency 'bootstrap-sass', '~> 3.3.4'
  s.add_dependency 'sass-rails', '~> 5.0'
end
