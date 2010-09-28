require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/geometry_spec')

module BeamTracerEnvironment
  include GeometryEnvironment

  def setup_beam_tracer
    setup_geometry
    setup_listener
    setup_sources
    @tracer = BeamTracer.new(@geometry, @sources, @listener)
  end

  def setup_listener
    @listener = Listener.new(Vector.new(120,160),
                             Vector.new(30,30))
  end

  def setup_sources
    @sources = [Source.new(Vector.new(50,50))]
  end
end

describe BeamTracer do
  include BeamTracerEnvironment

  before do
    setup_beam_tracer
  end

  it "should initialize with geometry, source, listener" do
    @tracer.should be_instance_of BeamTracer
  end

  it "should return Matrix when get normalizer" do
    segment = @geometry.lines[0]
    @tracer.normalizer(segment).should be_instance_of Matrix
  end

  it "should return BeamTracer when normalized" do
    result = @tracer.normalize(@geometry.lines[0])
    result.should be_instance_of BeamTracer
  end

  it "should have Ray which length is 2 at normalized geometry" do
    tracer = @tracer.normalize(@geometry.lines[0])
    length = tracer.geometry.lines[0].delta.length
    length.should < 2.01
    length.should > 1.99
  end

  it "should have Listener which position.x < 0 when normalized" do
    normalized_tracer = @tracer.normalize(@geometry.lines[0])
    normalized_tracer.listener.position.x.should < 0
  end
end
