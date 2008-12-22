require 'test/unit'
require File.dirname(__FILE__) + '/../lib/csquares'

class TestCSquares < Test::Unit::TestCase
  def test_squares
    assert_equal "7307:487:380:383:495:2",  CSquare.new(38.8894,-77.0356).sq(0.0005)
    assert_equal "7307:487:380:383:495",    CSquare.new(38.8894,-77.0356).sq(0.001)
    assert_equal "7307:487:380:383:4",      CSquare.new(38.8894,-77.0356).sq(0.005)
    assert_equal "7307:487:380:383",        CSquare.new(38.8894,-77.0356).sq(0.01)
    assert_equal "7307:487:380:3",          CSquare.new(38.8894,-77.0356).sq(0.05)
    assert_equal "7307:487:380",            CSquare.new(38.8894,-77.0356).sq(0.1)
    assert_equal "7307:487:3",              CSquare.new(38.8894,-77.0356).sq(0.5)
    assert_equal "7307:487",                CSquare.new(38.8894,-77.0356).sq(1)
    assert_equal "7307:4",                  CSquare.new(38.8894,-77.0356).sq(5)
    assert_equal "7307",                    CSquare.new(38.8894,-77.0356).sq(10)
  end
end
