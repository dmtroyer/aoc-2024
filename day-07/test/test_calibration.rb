# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/calibration'

# Test Calibration
class TestCalibration < Minitest::Test
  def test_parse_line
    assert_equal [42, [1, 2, 3]], Calibration.parse_line('42: 1 2 3')
  end

  def test_has_solution
    assert Calibration.solution?(6, [1, 2, 3])
    refute Calibration.solution?(10, [1, 2, 3])
  end

  def test_eval_equation
    assert_equal 9, Calibration.eval_equation([1, 2, 3], %i[+ *])
  end

  def test_calculate_sum
    lines = ['6: 1 2 3', '10: 1 2 3']
    assert_equal 6, Calibration.calculate_sum(lines)
  end
end
