require 'spec_helper'

describe BeamTracer do
  before { setup_beam_tracer }
  let(:geometry) { @geometry }
  subject { @tracer }

  describe "#generate_beam_tree" do
    let(:listener) { @listener }

    it "returns BeamTree" do
      geometry = double("geometry")
      geometry.should_receive(:generate_beam_tree).with(listener) { |i| BeamTree.new(i) }
      @tracer.generate_beam_tree(geometry, listener).should be_a BeamTree
    end
  end
end
