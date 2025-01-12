use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    // File hosts.txt must exist in the current path
    if let Ok(lines) = read_lines("input.txt") {
        let mut safe_reports = 0;

        // Consumes the iterator, returns an (Optional) String
        for line in lines.flatten() {
            let mut increasing: Option<bool> = None;
            let mut prev_score: Option<i32> = None;
            let mut safe = true;

            for string_score in line.split(" ") {
                let score = string_score.parse::<i32>().unwrap();
                if let Some(ps) = prev_score {
                    let diff = ps - score;
                    if let Some(i) = increasing {
                        if i && !(1..=3).contains(&diff) {
                            // continue if diff < 1 or > 3
                            safe = false;
                            break;
                        } else if !i && !(-3..=-1).contains(&diff) {
                            // break if diff < -3 or > -1
                            safe = false;
                            break;
                        }
                    } else {
                        // break if diff < 1 or > 3
                        // break if diff < -3 or > -1
                        if !(1..=3).contains(&diff) && !(-3..=-1).contains(&diff) {
                            safe = false;
                            break;
                        }
                        increasing = Some(diff > 0);
                    }
                }
                prev_score = Some(score);
            }
            if safe {
                safe_reports += 1;
            }
        }

        println!("Safe Reports: {}", safe_reports);
    }
}

// The output is wrapped in a Result to allow matching on errors.
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
