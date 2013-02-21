require 'minitest/spec'
require 'minitest/autorun'

$:.unshift "lib"
require 'gol.rb'

describe 'GameOfLife' do
  before do
    @gol1x1 = GameOfLife.new([[false]])
    @gol5x5 = GameOfLife.new([[false]*5]*5)
    @gol3x3 = GameOfLife.new([[true, false, true], [false, true, false], [true, false, false]])
  end

  describe 'when created' do
    it 'must raise an Argument Error when seed is not an Array of Rows' do
      proc { GameOfLife.new(:something) }.must_raise ArgumentError
      proc { GameOfLife.new([:something]) }.must_raise ArgumentError
      proc { GameOfLife.new([[:someting]])}.must_raise ArgumentError
      proc { GameOfLife.new([true, false],[true])}.must_raise ArgumentError
    end

    it 'must be created when seed is well formed' do
      GameOfLife.new([[true]]).is_a?(GameOfLife).must_equal true
    end

    it 'must have a generation of 0' do
      GameOfLife.new([[false]]).generation.must_equal 0
    end

    it 'the frame must be equal to the seed' do
      seed = [[false, true], [true, false]]
      GameOfLife.new(seed).frame.must_equal seed
    end

    it 'the number of columns and rows is present' do
      GameOfLife.new([[false]]).x_size.must_equal 1
      GameOfLife.new([[false]]).y_size.must_equal 1
    end

    it 'has accessable cells' do
      GameOfLife.new([[false]]).alive?(0,0).must_equal false
    end

    it 'has a method which returns an Array of neighbors of a cell' do
      @gol3x3.neighbors(1,1).size.must_equal 8
      @gol3x3.neighbors(1,1).must_equal [true, false, true, false, false, true, false, false]
      @gol3x3.neighbors(0,1).size.must_equal 5
      @gol3x3.neighbors(0,1).must_equal [true, true, false, true, false]
      @gol3x3.neighbors(0,0).size.must_equal 3
      @gol3x3.neighbors(0,0).must_equal [false, false, true]
    end

    it 'will obey to rule #1' do
      seed = [[false, false, false],[false, true, false],[false, false, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal false
      seed = [[false, false, false],[true, true, false],[false, false, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal false
    end

    it 'will obey to rule #2' do
      seed = [[false, false, false],[true, true, true],[false, false, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal true
      seed = [[false, true, false],[false, true, false],[false, true, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal true

      seed = [[false, false, false],[true, true, false],[true, true, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal true
      seed = [[false, true, true],[false, true, false],[false, true, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal true
    end

    it 'will obey to rule #3' do
      seed = [[true, true, true],[true, true, true],[true, true, true]]
      GameOfLife.new(seed).will_live?(1,1).must_equal false
      seed = [[true, true, false],[false, true, false],[true, true, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal false
    end

    it 'will obey to rule #4' do
      seed = [[true, true, true],[false, false, false],[false, false, false]]
      GameOfLife.new(seed).will_live?(1,1).must_equal true
    end
  end

  describe 'when evolving' do
    it 'increases the generation by one' do
      x = @gol1x1.generation
      @gol1x1.evolve!.generation.must_equal (x + 1)
    end

    it 'still live Block will stay the same' do
      seed = [[false]*4,[false, true, true, false],[false, true, true, false], [false]*4]
      GameOfLife.new(seed).evolve!.frame.must_equal seed
    end

    it 'occilator blinker will evolve' do
      state1 = [[false]*5, [false]*5, [false, true, true, true, false], [false]*5, [false]*5]
      state2 =[[false]*5, [false, false, true, false, false], [false, false, true, false, false],
               [false, false, true, false, false], [false]*5]
      GameOfLife.new(state1).evolve!.frame.must_equal state2
      GameOfLife.new(state2).evolve!.frame.must_equal state1
    end
  end

end
