#!/usr/bin/env ruby

lists = [[], []]

# Process the file
File.foreach('input.txt') do |line|
  a, b = line.split(' ').map(&:to_i)
  lists[0] << a
  lists[1] << b
end

# Sort 'em
lists.each(&:sort!)

# Calculate the total distance
total_distance = lists[0].zip(lists[1]).sum { |a, b| (a - b).abs }

puts "Total Distance: #{total_distance}"

# Calculate the similarity score
tally = lists[1].tally
similarity_score = lists[0].sum { |n| tally.fetch(n, 0) * n }

puts "Similarity Score: #{similarity_score}"
