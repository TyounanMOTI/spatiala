class Crack
  attr_accessor :line, :rays

  def initialize(line, *rays)
    @line = line
    @rays = rays
  end
end
