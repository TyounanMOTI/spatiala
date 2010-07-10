require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Geometry do
  before do
    triangle = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    rectangle = Polygon.new(Vector.new(50,30),
                            Vector.new(100,40),
                            Vector.new(100,400),
                            Vector.new(60,300))
    @geometry = Geometry.new(triangle, rectangle)
  end

  it "should generate instance" do
    Geometry.new.should be_instance_of Geometry
  end

  it "should be initialized by including polygons" do
    @geometry.should be_instance_of Geometry
  end

  it "should have including polygons" do
    @geometry.polygons.each { |i| i.should be_instance_of Polygon }
  end
end
