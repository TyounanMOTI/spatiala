require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CrackList do
  before do
    @line1 = Ray.new(Vector.new(1,0), Vector.new(10,20))
    @line2 = Ray.new(Vector.new(2,0), Vector.new(30,40))
    @ray1 = Ray.new(Vector.new(4,20), Vector.new(1,0))
    @ray2 = Ray.new(Vector.new(30,2), Vector.new(3,5))
    @crack1 = Crack.new(@line1, @ray1)
    @crack2 = Crack.new(@line2, @ray2)
    @crack3 = Crack.new(@line1, @ray2)
    @list = CrackList.new(@crack1)
  end

  it "should initialize with Cracks" do
    @list.should be_instance_of CrackList
  end

  it "should have cracks" do
    @list.should be_instance_of CrackList
    @list.each { |i| i.should be_instance_of Crack }
  end

  it "should append new crack to list when there are'nt already exist crack which have same line" do
    previous_length = @list.cracks.length
    @list.append @crack2
    @list.cracks.length.should == previous_length + 1
  end

  it "should append to existing crack when there are already exist crack which have same line" do
    previous_length = @list.cracks.length
    @list.append @crack3
    @list.cracks.length.should == previous_length
  end
end
