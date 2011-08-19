$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler'
Bundler.setup :default, :test

require 'spec'
require 'spec/autorun'

# Load extension
require 'fakememcached'

Spec::Runner.configure do |config|
end
