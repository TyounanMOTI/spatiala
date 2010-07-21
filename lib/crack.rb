class Crack
  attr_accessor :line, :rays

  def initialize(line, *rays)
    @line = line
    @rays = rays
  end

  def sort!
    if (@rays[0].delta.cross(@rays[1].delta)).z < 0
      @rays.reverse!
    end
  end
end
