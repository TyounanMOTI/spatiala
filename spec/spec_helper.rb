$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'vector'
require 'ray'
require 'polygon'
require 'geometry'
require 'beam'
require 'listener'
require 'source'
require 'beam_tracer'
require 'crack'
require 'crack_list'
require 'matrix'
require 'visibility_map'
require 'visibility_region'
require 'intersection'

RSpec.configure do |config|
  include Math
end

RSpec::Matchers.define :be_collection do |collection_class|
  match do |collection|
    collection.kind_of?(collection_class) && collection.reject {|i| i.kind_of?(@element_class)}
  end

  chain :of do |klass|
    @element_class = klass
  end
end

