class BeamTree
  attr_accessor :children

  def initialize(listener)
    @listener = listener
    @children = []
  end

  def traverse
    @children.each { |i| i.traverse }
    return self
  end
end
