# frozen_string_literal: true

require 'set'

module GardenCost
  DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

  def self.run(file_path)
    map = build_map(file_path)
    regions = find_regions(map)
    price = regions.sum { |region| region.size * num_region_fences(region) }
    discounted_price = regions.sum { |region| region.size * num_region_sides(region) }
    puts "The cost is #{price}."
    puts "The discounted cost is #{discounted_price}."
  end

  def self.build_map(file_path)
    File.readlines(file_path).map(&:chomp).map(&:chars)
  end

  def self.find_regions(map)
    rows, cols = map.size, map[0].size
    visited = Array.new(rows) { Array.new(cols, false) }
    regions = []

    (0...rows).each do |row|
      (0...cols).each do |col|
        next if visited[row][col]

        region = explore_region(map, visited, row, col)
        regions << region unless region.empty?
      end
    end

    regions
  end

  def self.valid_position?(rows, cols, r, c)
    r.between?(0, rows - 1) && c.between?(0, cols - 1)
  end

  def self.explore_region(map, visited, start_row, start_col)
    rows, cols = map.size, map[0].size
    value = map[start_row][start_col]
    region = []
    stack = [[start_row, start_col]]

    until stack.empty?
      r, c = stack.pop
      next unless valid_position?(rows, cols, r, c) && !visited[r][c] && map[r][c] == value

      visited[r][c] = true
      region << [r, c]

      DIRECTIONS.each { |dr, dc| stack << [r + dr, c + dc] }
    end

    region
  end

  def self.num_region_fences(region)
    region_set = region.to_set

    region.sum do |plot_r, plot_c|
      neighbors = DIRECTIONS.count { |dr, dc| region_set.include?([plot_r + dr, plot_c + dc]) }
      4 - neighbors
    end
  end

  def self.num_region_sides(region)
    region_set = region.to_set
    sides = 0

    DIRECTIONS.each do |dr, dc|
      boundary_plots = boundary_plots(region_set, dr, dc)
      visited = Set[]

      boundary_plots.each do |plot|
        next if visited.include?(plot)

        neighbor = [plot[0] + dr, plot[1] + dc]
        next if region_set.include?(neighbor)

        sides += 1
        visited.merge(side_plots(plot, boundary_plots, dr, dc))
      end
    end

    sides
  end

  def self.boundary_plots(region_set, dr, dc)
    region_set.reject do |plot_r, plot_c|
      neighbor = [plot_r + dr, plot_c + dc]
      region_set.include?(neighbor)
    end
  end

  # plots in a region sharing the same side as the given plot
  def self.side_plots(plot, boundaries, dr, dc)
    side_plots = Set[plot]
    traversal_directions = side_direction_to_neighbor_directions([dr, dc])

    traversal_directions.each do |tr, tc|
      i = 1
      loop do
        neighbor = [plot[0] + i * tr, plot[1] + i * tc]
        break unless boundaries.include?(neighbor)  # Stop if neighbor is not in the region

        side_plots << neighbor
        i += 1
      end
    end

    side_plots
  end

  def self.side_direction_to_neighbor_directions(side_direction)
    if [[-1, 0], [1, 0]].include?(side_direction)
      [[0, -1], [0, 1]]
    else
      [[-1, 0], [1, 0]]
    end
  end
end

GardenCost::run(ARGV[0]) if __FILE__ == $PROGRAM_NAME
