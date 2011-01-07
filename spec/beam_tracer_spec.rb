require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/geometry_spec')

module BeamTracer::Environment
  include Geometry::Environment

  def setup_beam_tracer
    setup_geometry
    setup_listener
    setup_sources
    @tracer = BeamTracer.new(@geometry, @sources, @listener)
  end

  def setup_listener
    @listener = Listener.new(Vector.new(100,200), Vector.new(30,30))
  end

  def setup_sources
    @sources = [Source.new(Vector.new(50,50))]
  end
end

describe BeamTracer, "when initialized with geometry, source, listener" do
  include BeamTracer::Environment
  before do
    setup_beam_tracer
    @window = @geometry.lines[0]
  end

  subject { @tracer }

  it { should be_a BeamTracer }
  specify { subject.normalizer(@window).should be_a Matrix }

  describe "and normalized by @window" do
    subject { @tracer.normalize(@window) }

    it { should be_a BeamTracer }
    its("listener.position.x") { should < 0 }

    it "should have Ray which length is 2 at normalized geometry" do
      length = subject.geometry.lines[0].delta.length
      length.should < 2.01
      length.should > 1.99
    end
  end
end
