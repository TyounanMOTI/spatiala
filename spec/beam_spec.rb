require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Beam do
  subject { Beam.new([Vector.new(400,40), Vector.new(30,300)]) }

  it { should be_a Beam }
  specify { described_class.superclass.should == Polygon }

  describe "#initialize" do
    its(:vertices) { should == [Vector.new(400,40), Vector.new(30,300)] }
    its(:children) { should be_instance_of Array }
  end
end
