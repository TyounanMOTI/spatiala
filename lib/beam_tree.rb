class BeamTree
  attr_accessor :children

  def initialize(listener)
    @listener = listener
    @children = []
  end

  def generate_children
    @children.each { |i| i.generate_children }
    return self
  end
end
