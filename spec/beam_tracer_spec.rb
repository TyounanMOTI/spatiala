require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe BeamTracer do
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
  end

  it "should initialize with geometry, source, listener" do
    @tracer.should be_instance_of BeamTracer
  end

  it "should return true when Ray((50,50), (60,60)) intersect_with_no_walls?" do
    ray = Ray.new(Vector.new(50, 50), Vector.new(60, 60))
    @tracer.intersect_with_no_walls?(ray).should == true
  end

  it "should return false when Ray((50,50), (500,500)) intersect_with_no_walls?" do
    ray = Ray.new(Vector.new(50, 50), Vector.new(500, 500))
    @tracer.intersect_with_no_walls?(ray).should == false
  end

  it "should return Array of Ray when get split_ray_list" do
    list = @tracer.split_ray_list
    list.should be_instance_of Array
    list.each { |i| i.should be_instance_of Ray }
  end
end
