require 'spec_helper'

describe BeamTree do
  before { setup_listener }
  let(:listener) { @listener }

  describe "#traverse" do
    it "tells children to traverse, and finally returns self" do
      beam = double("beam")
      tree = BeamTree.new(listener, [beam])
      beam.should_receive(:traverse).once
      tree.traverse.should be tree
    end
  end
end
