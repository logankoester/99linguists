require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "99linguists"
    gem.summary = %Q{'Bonjour'.translate.to :english # => 'Hello'}

    gem.description = <<-eos
99linguists extends Kernel#String with awesome lingual translation powers. The default engine
is Google's Translation API, but you saw that coming. Here's the cool part:
  
It can also leverage the "Freelancer":http://www.freelancer.com/affiliates/logankoester/ API to have your string translated 
professionally by a human, and handle all aspects of posting the project, choosing a candidate, downloading the result
and paying them for their work...completely without your intervention!
    eos

    gem.email = "logan@logankoester.com"
    gem.homepage = "http://github.com/logankoester/99linguists"
    gem.authors = ["Logan Koester"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_dependency "google-translate", ">= 0.6.8"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "99linguists #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
