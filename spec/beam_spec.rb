require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Beam do
  let(:beam) { Beam.new([Vector.new(400,40),
                         Vector.new(30,300),
                         Vector.new(100,200)
                        ]) }
  subject { beam }

  it { should be_a Beam }
  specify { described_class.superclass.should == Polygon }

  describe "#initialize" do
    its(:vertices) { should == [Vector.new(400,40), Vector.new(30,300), Vector.new(100,200)] }
    its(:children) { should be_instance_of Array }
  end

  describe "#transform" do
    subject { beam.transform(Matrix::Translator[1,2,3]) }
    it { should be_a Beam }
    its("vertices.first.z") { should == 3 }
  end

  describe "#illuminator" do
    subject { beam.illuminator }
    it { should be_a Ray }
    it { should == Ray.new(Vector.new(30,300), Vector.new(100,200)) }
  end
end

describe Beams do
  let(:beams) do
    Beams.new([
               Beam.new([Vector.new(1,2), Vector.new(2,3)]),
               Beam.new([Vector.new(4,5), Vector.new(6,7)])
              ])
  end

  describe "#transform" do
    subject { beams.transform(Matrix::Translator[1,2,3]) }
    it { should be_collection(Beams).of(Beam) }
  end
end
