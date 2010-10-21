class Source
  attr_accessor :position

  def initialize(position)
    @position = position
  end

  def transform(transformer)
    Source.new(@position.transform(transformer))
  end
end
