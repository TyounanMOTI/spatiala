require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CrackList do
  before do
    @line1 = Ray.new(Vector.new(1,0), Vector.new(10, 20))
    @ray1 = Ray.new(Vector.new(4,20), Vector.new(1,0))
    @crack1 = Crack.new(@line1, @ray1)
    @list = CrackList.new(@crack1)
  end

  it "should initialize with Cracks" do
    @list.should be_instance_of CrackList
  end

  it "should have cracks" do
    @list.cracks.should be_instance_of Array
    @list.cracks.each { |i| i.should be_instance_of Crack }
  end
end
