# frozen_string_literal: true

require 'matrix'

module ResonantCollinearity
  class Map
    attr_reader :antennas_by_frequency, :size

    def initialize(grid_lines)
      @antennas_by_frequency = build_frequency_locations(grid_lines)
      @size = [grid_lines.first.length, grid_lines.length].freeze
    end

    def antinode_locations_part_one
      antennas_by_frequency.flat_map do |_, antennas|
        antennas.permutation(2).filter_map do |a1, a2|
          antinode = calculate_antinode_part_one(a1, a2).to_a
          antinode if location_on_map?(antinode)
        end
      end.uniq
    end

    def antinode_locations_part_two
      antennas_by_frequency.flat_map do |_, antennas|
        generate_antinode_locations_part_two(antennas)
      end.uniq
    end

    private

    def build_frequency_locations(grid_lines)
      Hash.new { |h, k| h[k] = [] }.tap do |locations|
        grid_lines.each_with_index do |line, y|
          line.chars.each_with_index do |char, x|
            locations[char] << Vector[x, y] unless char == '.'
          end
        end
      end
    end

    def calculate_antinode_part_one(node1, node2)
      2 * node1 - node2
    end

    # Calculate antinodes between two antenna points
    def calculate_antinodes_part_two(antenna1, antenna2)
      primitive = (antenna1 - antenna2).to_primitive
      antinodes = Enumerator.new do |yielder|
        antinode = antenna1 - primitive
        while location_on_map?(antinode)
          yielder << antinode
          antinode -= primitive
        end
      end

      antinodes.to_a + [antenna2]
    end

    # Generate all antinode locations for a set of antennas
    def generate_antinode_locations_part_two(antennas)
      antennas.permutation(2).flat_map do |a1, a2|
        calculate_antinodes_part_two(a1, a2)
      end
    end

    def location_on_map?(location)
      (0...size[0]).include?(location[0]) && (0...size[1]).include?(location[1])
    end
  end
end

class Vector
  # Add a method to reduce the vector to its primitive form
  def to_primitive
    raise 'Only 2D vectors are supported' unless size == 2

    gcd = self[0].gcd(self[1])
    Vector[self[0] / gcd, self[1] / gcd]
  end
end
