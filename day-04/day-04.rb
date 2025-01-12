#!/usr/bin/env ruby

def self.run
  lines = File.readlines('input.txt', chomp: true)
  matches = 0

  lines.each_with_index do |line, i|
    j = 0
    line.each_char do |char|
      matches += self.count_xmases(i, j, lines) if char == 'X'
      j += 1
    end
  end

  puts "Number of xmases: #{matches}"
end

def self.count_xmases(i, j, lines)
  count = 0
  if self.has_forwards_xmas(i, j, lines)
    count += 1
    # puts "Forward xmas at #{i},#{j}"
  end
  if self.has_backwards_xmas(i, j, lines)
    count += 1
    # puts "Backward xmas at #{i},#{j}"
  end
  if self.has_downwards_xmas(i, j, lines)
    count += 1
    # puts "Downwards at #{i},#{j}"
  end
  count += 1 if self.has_upwards_xmas(i, j, lines)
  count += 1 if self.has_nw_xmas(i, j, lines)
  count += 1 if self.has_ne_xmas(i, j, lines)
  count += 1 if self.has_sw_xmas(i, j, lines)
  count += 1 if self.has_se_xmas(i, j, lines)
  count
end

def self.has_forwards_xmas(i, j, lines)
  line = lines[i]
  j + 4 <= line.length && line[j] == 'X' && line[j+1] == 'M' && line[j+2] == 'A' && line[j+3] == 'S'
end

def self.has_backwards_xmas(i, j, lines)
  line = lines[i]
  j > 2 && line[j] == 'X' && line[j-1] == 'M' && line[j-2] == 'A' && line[j-3] == 'S'
end

def self.has_downwards_xmas(i, j, lines)
  return false if i + 4 > lines.length
  word = lines[i][j] + lines[i+1][j] + lines[i+2][j] + lines[i+3][j]
  word == 'XMAS'
end

def self.has_upwards_xmas(i, j, lines)
  return false if i < 3
  word = lines[i][j] + lines[i-1][j] + lines[i-2][j] + lines[i-3][j]
  word == 'XMAS'
end

def self.has_nw_xmas(i, j, lines)
  return false if i < 3 || j < 3
  word = lines[i][j] + lines[i-1][j-1] + lines[i-2][j-2] + lines[i-3][j-3]
  word == 'XMAS'
end

def self.has_ne_xmas(i, j, lines)
  return false if j + 4 > lines[i].length || i < 3
  word = lines[i][j] + lines[i-1][j+1] + lines[i-2][j+2] + lines[i-3][j+3]
  word == 'XMAS'
end

def self.has_se_xmas(i, j, lines)
  return false if i + 4 > lines.length || j + 4 > lines[i].length
  word = lines[i][j] + lines[i+1][j+1] + lines[i+2][j+2] + lines[i+3][j+3]
  word == 'XMAS'
end

def self.has_sw_xmas(i, j, lines)
  return false if j < 3 || i + 4 > lines.length
  word = lines[i][j] + lines[i+1][j-1] + lines[i+2][j-2] + lines[i+3][j-3]
  word == 'XMAS'
end


run()


