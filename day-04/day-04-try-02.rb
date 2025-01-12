#!/usr/bin/env ruby
WORD = 'XMAS'.freeze
DIRECTIONS = [-1, 0, 1].repeated_permutation(2).reject { |dx, dy| dx.zero? && dy.zero? } # Remove [0,0]

def self.run
  grid = File.readlines('input.txt', chomp: true)
  matches = 0

  grid.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      matches += self.count_xmases(x, y, grid) if char == 'X'
    end
  end

  puts "Number of xmases: #{matches}"
end

def in_bounds?(x, y, grid)
  y.between?(0, grid.size - 1) && x.between?(0, grid[y].size - 1)
end

def count_xmases(x, y, grid)
  DIRECTIONS.count do |dx, dy|
    WORD.chars.each_with_index.all? do |char, i|
      nx = x + dx * i
      ny = y + dy * i
      in_bounds?(nx, ny, grid) && grid[ny][nx] == char
    end
  end
end

run()
