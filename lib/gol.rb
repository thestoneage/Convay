
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
    @frame.size
  end

  def y_size
    @frame.first.size
  end

  def alive?(row, column)
    @frame[row][column]
  end

  def will_live?(row, column)
    n = neighbors(row, column).count(true)
    if (n == 3)
      return true
    elsif (n == 2 and alive?(row, column))
      return true
    else
      return false
    end
  end

  def neighbors(row, column)
    nbs = []
    ([0,(row - 1)].max..[(row + 1),x_size-1].min).each do |x|
      ([0,(column - 1)].max..[(column + 1),y_size-1].min).each do |y|
        nbs << alive?(x, y) unless (x==row and y==column)
      end
    end
    nbs
  end

  private

  def compute_next_frame
    next_frame = []
    @frame.each { |row| next_frame << row.clone }
    x_size.times do |x|
      y_size.times do |y|
        next_frame[x][y] = will_live?(x, y)
      end
    end
    next_frame
  end

end
