require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Source do
  before do
    @source = Source.new(Vector.new(300,50))
  end

  it "should be initialized with its position" do
    @source.should be_instance_of Source
  end

  it "should have position" do
    @source.position.should == Vector.new(300,50)
  end

  it "should return Source when transformed" do
    @source.transform(Matrix.translator(3,3)).should be_instance_of Source
  end
end
