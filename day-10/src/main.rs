use std::collections::HashSet;
use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader};

#[derive(Debug)]
enum BuildMapError {
    Io(io::Error),
    Parse(String),
}

impl From<io::Error> for BuildMapError {
    fn from(err: io::Error) -> Self {
        BuildMapError::Io(err)
    }
}

fn build_map(map_path: &str) -> Result<Vec<Vec<u8>>, BuildMapError> {
    let reader = BufReader::new(File::open(map_path)?);

    reader
        .lines()
        .map(|line| {
            line?.chars()
                .map(|ch| {
                    ch.to_digit(10)
                        .ok_or_else(|| BuildMapError::Parse(format!("Invalid character: {}", ch)))
                        .and_then(|d| {
                            u8::try_from(d).map_err(|_| {
                                BuildMapError::Parse(format!("Value out of range: {}", d))
                            })
                        })
                })
                .collect::<Result<Vec<u8>, BuildMapError>>()
        })
        .collect()
}

fn find_neighbors(map: &Vec<Vec<u8>>, point: (usize, usize)) -> Vec<(usize, usize)> {
    let elevation = map[point.1][point.0];
    let mut neighbors: Vec<(usize, usize)> = Vec::new();
    // West
    if point.0 > 0 && map[point.1][point.0-1] == elevation + 1 {
        neighbors.push((point.0-1, point.1));
    }
    // North
    if point.1 > 0 && map[point.1-1][point.0] == elevation + 1 {
        neighbors.push((point.0, point.1-1));
    }
    // East
    if point.0 + 1 < map[0].len() && map[point.1][point.0+1] == elevation + 1 {
        neighbors.push((point.0+1, point.1));
    }
    // South
    if point.1 + 1 < map.len() && map[point.1+1][point.0] == elevation + 1 {
        neighbors.push((point.0, point.1+1));
    }
    neighbors
}

fn find_num_paths(map: &Vec<Vec<u8>>, point: (usize, usize)) -> usize {
    let mut found_paths = 0;
    let mut to_explore = vec![point];
    while !to_explore.is_empty() {
        if let Some(exploring) = to_explore.pop() {
            if map[exploring.1][exploring.0] == 9 {
                found_paths += 1;
            } else {
                to_explore.append(&mut find_neighbors(&map, exploring));
            }
        }
    }
    found_paths
}

fn find_num_peaks(map: &Vec<Vec<u8>>, point: (usize, usize)) -> usize {
    let mut found_peaks = HashSet::new();
    let mut to_explore = vec![point];
    while !to_explore.is_empty() {
        if let Some(exploring) = to_explore.pop() {
            if map[exploring.1][exploring.0] == 9 {
                found_peaks.insert(exploring);
            } else {
                to_explore.append(&mut find_neighbors(&map, exploring));
            }
        }
    }
    return found_peaks.len();
}

fn find_starting_points(map: &Vec<Vec<u8>>) -> Vec<(usize, usize)> {
    map.iter()
        .enumerate()
        .flat_map(|(i, row)| {
            row.iter()
                .enumerate()
                .filter(|&(_, &value)| value == 0)
                .map(move |(j, _)| (j, i))
        })
        .collect()
}

fn main() {
    // Get command-line arguments
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <file_path>", args[0]);
        std::process::exit(1);
    }

    let file_path = &args[1];

    let map = match build_map(file_path) {
        Ok(map) => map,
        Err(BuildMapError::Io(e)) => {
            eprintln!("I/O Error: {}", e);
            return;
        }
        Err(BuildMapError::Parse(e)) => {
            eprintln!("Parse Error: {}", e);
            return;
        }
    };

    let mut trailhead_scores: usize = 0;
    let mut num_paths: usize = 0;

    for point in find_starting_points(&map).iter() {
        trailhead_scores += find_num_peaks(&map, *point);
        num_paths += find_num_paths(&map, *point);
    }

    println!("Scores of trailheads: {}", trailhead_scores);
    println!("Number of paths: {}", num_paths);
}


