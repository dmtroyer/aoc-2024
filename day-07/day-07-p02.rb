#!/usr/bin/env ruby

def self.run
  lines = File.readlines('day-07/input.txt', chomp: true)

  sum = lines.reduce(0) do |acc, line|
    test_val, constants = parse_line(line)
    if has_solution?(test_val, constants)
      acc + test_val
    else
      acc
    end
  end

  puts "Sum of calibrations Part Two: #{sum}"
end

def self.parse_line(line)
  test_val, constants = line.split(": ")
  [test_val.to_i, constants.split(' ').map(&:to_i)]
end

def self.has_solution?(test_val, constants)
  [:+, :*, :"||"].repeated_permutation(constants.length - 1).any? do |operators|
    test_val == eval_equation(constants, operators)
  end
end

def self.eval_equation(constants, operators)
  constants.drop(1).zip(operators).inject(constants.first) do |acc, (constant, operator)|
    if (operator == :"||")
      (acc.to_s + constant.to_s).to_i
    else
      acc.send(operator, constant)
    end
  end
end

run()
