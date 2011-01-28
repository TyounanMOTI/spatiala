require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Beam do
  let(:beam) { Beam.new([Vector.new(400,40), Vector.new(30,300)]) }
  subject { beam }

  it { should be_a Beam }
  specify { described_class.superclass.should == Polygon }

  describe "#initialize" do
    its(:vertices) { should == [Vector.new(400,40), Vector.new(30,300)] }
    its(:children) { should be_instance_of Array }
  end

  describe "#transform" do
    subject { beam.transform(Matrix::Translator[1,2,3]) }
    it { should be_a Beam }
    its("vertices.first.z") { should == 3 }
  end
end
