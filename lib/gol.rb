
class GameOfLife
  attr_reader :generation, :frame

  def initialize(seed, generation = 0)
    raise ArgumentError unless seed.is_a?(Array)
    raise ArgumentError unless seed.all? { |row| row.is_a? Array }
    raise ArgumentError unless seed.all? { |row| row.all? {|cell| cell == true or cell == false } }
    raise ArgumentError unless seed.all? { |row| row.size == seed[0].size }
    @generation = generation
    @frame = []
    seed.each { |row| @frame << row.dup }
  end

  def evolve
    GameOfLife.new(compute_next_frame, @generation + 1)
  end

  def evolve!
    @generation += 1
    @frame = compute_next_frame
    self
  end

  def x_size
    @frame.first.size
  end

  def y_size
    @frame.size
  end

  def alive?(x, y)
    @frame[y][x]
  end

  def will_live?(x, y)
    n = neighbors(x, y).count(true)
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
        nbs << alive?(xi, yi) unless (xi == x and yi == y)
      end
    end
    nbs
  end

  private

  def compute_next_frame
    next_frame = Array.new(@frame.size) { Array.new(@frame.first.size, false) }
    x_size.times do |x|
      y_size.times do |y|
        next_frame[y][x] = will_live?(x, y)
      end
    end
    next_frame
  end

end
