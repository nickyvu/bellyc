# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','bellyc','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'bellyc'
  s.version = Bellyc::VERSION
  s.author = 'Nick Nguyen'
  s.email = 'nickhxnguyen@gmail.com'
  s.homepage = 'https://github.com/nickyvu'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Tools for scraping and analyzing check-in data from the Belly Card Admin Website'
# Add your other files here if you make them
  s.files = %w(
bin/bellyc
lib/bellyc/version.rb
lib/bellyc/config.rg
lib/bellyc/crawler.rb
lib/bellyc/checkin.rb
lib/bellyc/parser.rb
lib/bellyc/report.rb
lib/bellyc/csv_export.rb
lib/bellyc.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','bellyc.rdoc']
  s.rdoc_options << '--title' << 'bellyc' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'bellyc'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.8.0')
  s.add_runtime_dependency('data_mapper', '1.2.0')
  s.add_runtime_dependency('mechanize', '2.7.2')
  s.add_runtime_dependency('dm-postgres-adapter', '1.2.0')
  s.add_runtime_dependency('ruby-progressbar', '1.2.0')
end
