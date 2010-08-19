require "rubygems"
require "rake"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "arrcc"
    gem.summary = %Q{ActiveRecord Redis Counter Cache}
    gem.description = %Q{Replace default ActiveRecord's Counter Cache column with Redis}
    gem.email = "filip@tepper.pl"
    gem.homepage = "http://github.com/wrug/arrcc"
    gem.authors = ["Filip Tepper"]
    gem.add_development_dependency "rspec", ">= 2.0.0.beta.19"
    gem.add_development_dependency "rspec-mocks", ">= 2.0.0.beta.19"
    gem.add_development_dependency "mysql", ">= 2.8.1"
    gem.add_dependency "redis", ">= 2.0.0"
    gem.add_dependency "activerecord", ">= 3.0.0.rc"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |spec|
  # spec.libs << 'lib' << 'spec'
  # spec.spec_files = FileList['spec/**/*_spec.rb']
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "arrcc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
