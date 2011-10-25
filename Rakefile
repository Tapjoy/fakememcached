require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fakememcached"
    gem.summary = %Q{An in-memory hash implementation of memcached}
    gem.description = %Q{An in-memory hash implementation of memcached}
    gem.email = "viximo-eng@viximo.com"
    gem.homepage = "http://viximo.com"
    gem.authors = ["Viximo"]
    gem.license = "APACHE"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fakememcached #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
