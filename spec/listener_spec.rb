require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Listener do
  let(:listener) { Listener.new(Vector.new(10,10), Vector.new(40,50).normalize) }

  subject { listener }

  it { should be_instance_of Listener }
  its(:position) { should == Vector.new(10,10) }
  its(:direction) { should == Vector.new(40,50).normalize }

  describe "#normalize" do
    subject { listener.normalize(Matrix::Translator[2,3]) }
    it { should be_a Listener }
    its(:position) { should == Vector.new(12,13) }
  end

  describe "#dualize" do
    subject { listener.dualize }
    it { should == Ray.new(Vector.new(0.9,1), Vector.new(1.1,-1)) }
  end
end

