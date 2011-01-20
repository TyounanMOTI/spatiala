require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe BeamTracer, "when initialized with geometry, source, listener" do
  include BeamTracer::Environment
  before do
    setup_beam_tracer
  end

  subject { @tracer }
  it { should be_a BeamTracer }
end
