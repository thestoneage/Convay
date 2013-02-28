class Cell
  attr_reader :x, :y

  def initialize(x, y, state)
    @x, @y, @state = x, y, state
  end

  def ==(other)
    @x == other.x and @y == other.y and @state == other.state
  end

  def alive?
    @state
  end

  def alive=(state)
    @state = state
  end

  def will_live?
    @will_live
  end

  def will_live=(state)
    @will_live = state
  end
end

class GameOfLife
  attr_reader :generation, :frame
  include Enumerable

  def initialize(seed, generation = 0)
    raise ArgumentError unless seed.is_a?(Array)
    raise ArgumentError unless seed.all? { |row| row.is_a? Array }
    raise ArgumentError unless seed.all? { |row| row.all? { |v| v == true or v == false } }
    raise ArgumentError unless seed.all? { |row| row.size == seed[0].size }
    @generation = generation
    @frame = []
    seed.each_with_index do |row, y|
      @frame << row.each_with_index.map { |value, x| Cell.new(x, y, value) }
    end
  end

  def value
    @frame.map { |row| row.map { |cell| cell.alive? } }
  end

  def each
    @frame.each { |row| row.each { |cell| yield cell } }
  end

  def evolve!
    @generation += 1
    compute_next_frame
    self
  end

  def x_size
    @frame.first.size
  end

  def y_size
    @frame.size
  end

  def alive?(x, y)
    cell(x, y).alive?
  end

  def cell(x, y)
    @frame[y][x]
  end

  def will_live?(x, y)
    n = neighbors(x, y).count { |cell| cell.alive? == true }
    if (n == 3)
      return true
    elsif (n == 2 and alive?(x, y))
      return true
    else
      return false
    end
  end

  def neighbors(x, y)
    nbs = []
    ([0,(x - 1)].max..[(x + 1),x_size-1].min).each do |xi|
      ([0,(y - 1)].max..[(y + 1),y_size-1].min).each do |yi|
        nbs << cell(xi, yi) unless (xi == x and yi == y)
      end
    end
    nbs
  end

  private

  def compute_next_frame
    self.each do |cell|
      cell.will_live = will_live?(cell.x, cell.y)
    end
    self.each { |cell| cell.alive=cell.will_live?}
  end

end
