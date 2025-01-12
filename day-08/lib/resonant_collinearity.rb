#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'resonant_collinearity/map'

# Calculate Resonant Collinearity of antennas per AOC Day 8 2024
module ResonantCollinearity
  def self.run(file_path)
    lines = File.readlines(file_path, chomp: true)
    map = Map.new(lines)

    puts "Map Size: #{map.size}"
    puts "Antinodes Part One: #{map.antinode_locations_part_one.size}"
    puts "Antinodes Part Two: #{map.antinode_locations_part_two.size}"
  end
end

ResonantCollinearity.run(ARGV[0]) if __FILE__ == $PROGRAM_NAME
