require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ray do
  it "should generate instance" do
    Ray.new.should be_instance_of Ray
  end

  it "should origin=(3,4), destination(-6,0), delta=(-9,-4) when initialize in that origin, destination=(-6,0)" do
    ray = Ray.new(Vector.new(3,4), Vector.new(-6,0))
    ray.origin.should == Vector.new(3,4)
    ray.delta.should == Vector.new(-9,-4)
    ray.destination.should == Vector.new(-6,0)
  end

  it "should return a Float under 0 when intersect_as_directional_line (0,1)->(1,2) with (0,-1)->(1,-2)" do
    ray1 = Ray.new(Vector.new(0,1), Vector.new(1,2))
    ray2 = Ray.new(Vector.new(0,-1), Vector.new(1,-2))
    result = ray1.intersect_as_directional_line(ray2)
    result.should < 0
  end

  it "should return a Float between 0 and 1 when intersect (0,1)->(1,-2) with (0,-1)->(1,2)" do
    ray1 = Ray.new(Vector.new(0,1), Vector.new(1,-2))
    ray2 = Ray.new(Vector.new(0,-1), Vector.new(1,2))
    result = ray1.intersect(ray2)
    result.should < 1
    result.should > 0
  end

  it "should return nil when intersect (0,1)->(1,2) with (0,-1)->(1,-2)" do
    ray1 = Ray.new(Vector.new(0,1), Vector.new(1,2))
    ray2 = Ray.new(Vector.new(0,-1), Vector.new(1,-2))
    result = ray1.intersect(ray2)
    result.should == nil
  end

  it "should return nil when intersect (0,1)->(1,2) with (3,1)->(1,5)" do
    ray1 = Ray.new(Vector.new(0,1), Vector.new(1,2))
    ray2 = Ray.new(Vector.new(3,1), Vector.new(1,5))
    ray1.intersect(ray2).should be_nil
  end

  it "should re-compute delta when origin is changed" do
    ray = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray.origin = Vector.new(3,9)
    ray.delta.should == Vector.new(-1,-5)
  end

  it "should re-compute delta when destination is changed" do
    ray = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray.destination = Vector.new(3,9)
    ray.delta.should == Vector.new(2,9)
  end

  it "should re-compute destination when delta is changed" do
    ray = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray.delta = Vector.new(3,9)
    ray.destination.should == Vector.new(4,9)
  end

  it "should true when Ray((1,0),(4,2)) intersect? ((0,1),(3,4))" do
    ray = Ray.new(Vector.new(0,1), Vector.new(4,2))
    wall = Ray.new(Vector.new(1,0), Vector.new(3,4))
    ray.intersect?(wall).should == true
  end

  it "should true when (100,200)->(400,50) intersect? (100,100)->(250,130)" do
    ray = Ray.new(Vector.new(100,200), Vector.new(400,50))
    wall = Ray.new(Vector.new(100,100), Vector.new(250,130))
    ray.intersect?(wall).should == true
  end

  it "should true when Ray((1,0),(4,2)) == Ray((1,0),(4,2))" do
    Ray.new(Vector.new(1,0), Vector.new(4,2)).should == Ray.new(Vector.new(1,0), Vector.new(4,2))
  end

  it "should false when Ray((1,0),(4,2)) == Ray((0,1),(5,6))" do
    Ray.new(Vector.new(1,0), Vector.new(4,2)).should_not == Ray.new(Vector.new(0,1), Vector.new(5,6))
  end

  it "should transform Ray((1,0),(4,2)) to Ray((3,2),(6,4)) when Matrix.translator(2,2)" do
    Ray.new(Vector.new(1,0), Vector.new(4,2)).transform(Matrix.translator(2,2,0)).should == Ray.new(Vector.new(3,2), Vector.new(6,4))
  end

  it "should return VisibilityRegion when dualize" do
    Ray.new(Vector.new(4,2), Vector.new(1,0)).dualize.should be_instance_of VisibilityRegion
  end

  it "should have four Rays in VisibilityRegion when dualize Ray (3,-1) to (1,1)" do
    result = Ray.new(Vector.new(3,-1), Vector.new(1,1)).dualize
    result.rays.length.should == 4
  end

  it "should return nil when dualize Ray which isn't facing with reference refrector" do
    Ray.new(Vector.new(1,1), Vector.new(3,-1)).dualize.should be_nil
  end

  it "should return nil when dualize Ray which is right of y-axis" do
    Ray.new(Vector.new(-1,1), Vector.new(-1,-1)).dualize.should be_nil
  end

  it "should include x == BIG Rays in VisibilityRegion when dualize Ray (2,3) to (-1,1)" do
    region = Ray.new(Vector.new(2,3), Vector.new(-1,1)).dualize
    far_point = Vector.new(Ray::BIG, 1)
    region.vertices.include?(far_point).should == true
  end

  it "should include x == -BIG Rays in VisibilityRegion when dualize Ray (-1,-1) to (2,0)" do
    region = Ray.new(Vector.new(-1,-2), Vector.new(2,-2)).dualize
    far_point = Vector.new(-Ray::BIG, 1)
    region.vertices.include?(far_point).should == true
  end

  it "should have three Rays in VisibilityRegion when dualize Ray (1,0) to (3,0)" do
    result = Ray.new(Vector.new(1,0), Vector.new(3,0)).dualize
    result.rays.length.should == 3
  end

  it "should have Ray which is part of y=1 when dualize Ray (1,0) to (3,0)" do
    result = Ray.new(Vector.new(1,0), Vector.new(3,0)).dualize
    result.rays[0].origin.y.should == 1
  end

  it "should have Ray which is part of y=-1 when dualize Ray (3,0) to (1,0)" do
    result = Ray.new(Vector.new(3,0), Vector.new(1,0)).dualize
    result.rays[1].origin.y.should == -1
  end

  it "should return Vector when normal of Ray (1,1) to (3,-1) is requested" do
    normal = Ray.new(Vector.new(1,1), Vector.new(3,-1)).normal
    normal.should be_instance_of Vector
  end

  it "should return :false when questioned 'How refrector and Ray (1,1) to (2,-3) are facing?'" do
    ray = Ray.new(Vector.new(1,1), Vector.new(2,-3))
    ray.facing.should == :false
  end

  it "should return :upper when questioned 'How refrector and Ray (2,0) to (3,0) are facing?'" do
    ray = Ray.new(Vector.new(2,0), Vector.new(3,0))
    ray.facing.should == :upper
  end

  it "should return :lower when questioned 'How refrector and Ray (3,0) to (2,0) are facing?'" do
    ray = Ray.new(Vector.new(3,0), Vector.new(2,0))
    ray.facing.should == :lower
  end

  it "should return :true when questioned 'How refrector and Ray (2,-3) to (1,1) are facing?'" do
    ray = Ray.new(Vector.new(2,-3), Vector.new(1,1))
    ray.facing.should == :true
  end

  it "should return :true when questioned 'How refrector and Ray (0,-1) to (10,0)" do
    Ray.new(Vector.new(0,-1), Vector.new(10,0)).facing.should == :true
  end

  it "should return :false when questioned 'How refrector and Ray (10,0) to (0,-1)" do
    Ray.new(Vector.new(10,0), Vector.new(0,-1)).facing.should == :false
  end

  it "should return :true when questioned 'How refrector and Ray (10,0) to (0,1)" do
    Ray.new(Vector.new(10,0), Vector.new(0,1)).facing.should == :true
  end

  it "should return :false when questioned 'How refrector and Ray (0,1) to (10,0)" do
    Ray.new(Vector.new(0,1), Vector.new(10,0)).facing.should == :false
  end

  it "should return Ray (2,3) to (4,5) when reversed Ray (4,5) to (2,3)" do
    Ray.new(Vector.new(4,5), Vector.new(2,3)).reverse.should == Ray.new(Vector.new(2,3), Vector.new(4,5))
  end

  it "should return Ray which have BIG length when maximized Ray" do
    Ray.new(Vector.new(4,5), Vector.new(2,3)).maximize.delta.length.should > Ray::BIG-1
  end

  it "should return Ray(0,0)->(0,50) when Ray(0,0)->(0,100) * 0.5" do
    (Ray.new(Vector.new(0,0), Vector.new(0,100))*0.5).should == Ray.new(Vector.new(0,0), Vector.new(0,50))
  end
end

def print_ray(ray)
  Kernel.print "- Ray (%5.1f" % ray.origin.x, ",%5.1f" % ray.origin.y, ") to (%5.1f" % ray.destination.x, ",%5.1f" % ray.destination.y, ")\n"
end
