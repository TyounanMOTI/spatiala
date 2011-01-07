require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Crack do
  before do
    @ray1 = Ray.new(Vector.new(2,4), Vector.new(3,2))
    @ray2 = Ray.new(Vector.new(1,1), Vector.new(2,4))
    @ray3 = Ray.new(Vector.new(1,1), Vector.new(3,2))
    @crack = Crack.new(@ray1, @ray2, @ray3)
  end

  describe "#initialize" do
    it "should initialize with line and Rays" do
      Crack.new(@ray1, @ray2, @ray3).should be_a Crack
    end

    it "should initialize with line" do
      Crack.new(@ray1).should be_a Crack
    end
  end

  describe "its members" do
    it "should have line and rays" do
      @crack.line.should be_instance_of Ray
      @crack.rays.each { |i| i.should be_instance_of Ray }
    end
  end

  describe "#sort!" do
    it "can sort" do
      @crack.sort!
      (@crack.rays[0].delta.cross(@crack.rays[1].delta)).z.should > 0
    end
  end

  describe "#to_beam" do
    it "should return Beam when convert to_beam" do
       @crack.to_beam.should be_instance_of Beam
    end
  end
end
