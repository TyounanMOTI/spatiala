require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize
  end

  def initialize(*polygons)
    @polygons = polygons
  end
end
