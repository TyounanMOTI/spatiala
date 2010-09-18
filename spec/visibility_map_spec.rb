require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityMap do
  before do
    triangle = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    wall = Polygon.new(Vector.new(100, 100),
                       Vector.new(250, 130))

    @geometry = Geometry.new(triangle, wall)

    @sources = Array.new
    @sources.push(Source.new(Vector.new(50,50)))

    @listener = Listener.new(Vector.new(120,160),
                             Vector.new(30,30))

    @tracer = BeamTracer.new(@geometry, @sources, @listener)
    @map = VisibilityMap.new(@tracer)
  end

  it "should be initialized with BeamTracer" do
    @map.should be_instance_of VisibilityMap
  end

  it "should have regions which is Array of VisibilityRegion" do
    @map.regions.should be_instance_of Array
    @map.regions.each { |i| i.should be_instance_of VisibilityRegion }
  end

  it "should return IntersectionPoints class when get_instersection_points" do
    @map.get_intersection_points.should be_instance_of IntersectionPoints
  end
end
