require 'spec_helper'

describe BeamTree do
  before { setup_listener }
  let(:listener) { @listener }
  let(:tree) { BeamTree.new(listener) }

  describe "#generate_children" do
    it "tells children to generate_children" do
      beam = double("beam")
      tree.children = [beam]
      beam.should_receive(:generate_children).once
      tree.generate_children.should be tree
    end
  end
end
