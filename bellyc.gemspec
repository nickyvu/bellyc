# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','bellyc','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'bellyc'
  s.version = Bellyc::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
bin/bellyc
lib/bellyc/version.rb
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
end
