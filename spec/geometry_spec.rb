require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module GeometryEnvironment
  def setup_geometry
    triangle = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    wall = Polygon.new(Vector.new(100, 100),
                       Vector.new(250, 130))

    @geometry = Geometry.new(triangle, wall)
  end
end

describe Geometry do
  include GeometryEnvironment

  before do
    setup_geometry
    @view_ray = Ray.new(Vector.new(0,0), Vector.new(50,50))
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

  it "should return Array of Vector when get all vertices" do
    vertices = @geometry.vertices
    vertices.should be_instance_of Array
    vertices.each{ |i| i.should be_instance_of Vector }
  end

  it "should return Array of Ray when get all lines" do
    lines = @geometry.lines
    lines.should be_instance_of Array
    lines.each { |i| i.should be_instance_of Ray }
  end

  it "should return Array of Ray when get lines includes specified vertex" do
    vertex = Vector.new(50, 30)
    lines = @geometry.lines_include_vertex vertex
    lines.should be_instance_of Array
    lines.each { |i| i.should be_instance_of Ray }
  end

  it "should return a Ray when get nearest_intersect_line_with" do
    @geometry.nearest_intersect_line_with(@view_ray).should be_instance_of Ray
  end

  it "should return Ray (10,20) to (400,50) when get nearest_intersect_line_with Ray (0,0) to (50,50)" do
    @geometry.nearest_intersect_line_with(@view_ray).should == Ray.new(Vector.new(10,20), Vector.new(400,50))
  end

  it "should return Array of Vectors when get ends_of_lines" do
    vertices = @geometry.ends_of_lines
    vertices.should be_instance_of Array
    vertices.each { |i| i.should be_instance_of Vector }
  end

  it "should return double Vectors of lines when get ends_of_lines" do
    @geometry.ends_of_lines.length.should == @geometry.lines.length*2
  end
end
