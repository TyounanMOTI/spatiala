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
end
