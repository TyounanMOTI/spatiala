require 'spec_helper'

describe BeamTree do
  before { setup_listener }
  let(:listener) { @listener }
  let(:tree) { BeamTree.new(listener) }

  describe "#traverse" do
    it "tells children to traverse" do
      beam = double("beam")
      tree.children = [beam]
      beam.should_receive(:traverse).once
      tree.traverse.should be tree
    end
  end
end
