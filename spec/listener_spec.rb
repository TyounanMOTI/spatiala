require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Listener do
  let(:listener) { Listener.new(Vector.new(10,10), Vector.new(40,50).normalize) }

  subject { listener }

  it { should be_instance_of Listener }
  its(:position) { should == Vector.new(10,10) }
  its(:direction) { should == Vector.new(40,50).normalize }

  describe "#transform" do
    subject { listener.transform(Matrix::Translator[2,3]) }
    it { should be_a Listener }
    its(:position) { should == Vector.new(12,13) }
  end
end

