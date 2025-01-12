use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    if let Ok(lines) = read_lines("input.txt") {
        let safe_reports = lines
            .flatten() // Skip over lines that failed to read
            .filter(|line| is_safe_line(line))
            .count();

        println!("Safe Reports: {}", safe_reports);
    }
}

fn is_safe_line(line: &str) -> bool {
    let scores: Vec<i32> = line
        .split_whitespace() // Split the line into numbers
        .filter_map(|s| s.parse::<i32>().ok()) // Parse numbers, ignoring invalid ones
        .collect();

    if scores.len() < 2 {
        return true; // A single score or no score is trivially safe
    }

    let differences: Vec<i32> = scores
        .windows(2) // Get consecutive pairs
        .map(|pair| pair[1] - pair[0]) // Calculate differences
        .collect();

    let all_increasing = differences.iter().all(|&diff| (1..=3).contains(&diff));
    let all_decreasing = differences.iter().all(|&diff| (-3..=-1).contains(&diff));

    all_increasing || all_decreasing
}

// The output is wrapped in a Result to allow matching on errors.
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
