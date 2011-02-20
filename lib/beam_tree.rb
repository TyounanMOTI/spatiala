class BeamTree
  attr_reader :children

  def initialize(listener, children)
    @listener = listener
    @children = children
  end

  def traverse
    @children.each { |i| i.traverse }
    return self
  end
end
