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

require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  include Math
end
