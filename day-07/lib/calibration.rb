#!/usr/bin/env ruby
# frozen_string_literal: true

# Calibration for AOC Day 7
module Calibration
  def self.run(file_path)
    lines = File.readlines(file_path, chomp: true)

    sum = calculate_sum(lines)
    puts "Sum of calibrations: #{sum}"
  end

  def self.calculate_sum(lines)
    lines.reduce(0) do |acc, line|
      test_val, constants = parse_line(line)
      acc + (solution?(test_val, constants) ? test_val : 0)
    end
  end

  def self.parse_line(line)
    test_val, constants = line.split(': ')
    [test_val.to_i, constants.split(' ').map(&:to_i)]
  end

  def self.solution?(test_val, constants)
    %i[+ *].repeated_permutation(constants.length - 1).any? do |operators|
      test_val == eval_equation(constants, operators)
    end
  end

  def self.eval_equation(constants, operators)
    constants.reduce { |acc, constant| acc.send(operators.shift, constant) }
  end
end

# Only run when executed directly, not during testing
Calibration.run('day-07/input-test.txt') if __FILE__ == $PROGRAM_NAME
