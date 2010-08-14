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

  it "should return Matrix when get normalizer" do
    segment = @geometry.lines[0]
    @geometry.normalizer(segment).should be_instance_of Matrix
  end

  it "should have Ray length is 2 at normalized geometry" do
    normalized_segment = @geometry.normalize(@geometry.lines[0]).lines[0]
    length = normalized_segment.delta.length
    length.should < 2.01
    length.should > 1.99
  end

  it "should return Geometry when normalize" do
    segment = Ray.new(Vector.new(10,20), Vector.new(400,50))
    @geometry.normalize(segment).should be_instance_of Geometry
  end
end
