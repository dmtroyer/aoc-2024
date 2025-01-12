import * as fs from 'fs';
import * as readline from 'readline';

// Get the file path from command line arguments
const filePath = process.argv[2];

// Check if a file path was provided
if (!filePath) {
  console.error('Please provide a file path as an argument.');
  process.exit(1);
}

// Create a readable stream
const fileStream = fs.createReadStream(filePath);

// Create an interface for reading line by line
const rl = readline.createInterface({
  input: fileStream,
  output: process.stdout,
  terminal: false, // Prevents adding extra prompts
});

const rules = new Map<number, Set<number>>();
var correctMiddleSum = 0;
var incorrectMiddleSum = 0;

const ruleRegex = /^(\d+)\|(\d+)$/;
const updateRegex = /^\d+(?:,\d+)*$/;

// Process each line
rl.on('line', (line: string) => {
  const ruleMatch = ruleRegex.exec(line);
  const updateMatch = updateRegex.exec(line);

  if (ruleMatch) {
    const before = Number(ruleMatch[1]);
    const after = Number(ruleMatch[2]);
    const set = rules.get(before) ?? new Set<number>();

    set.add(after);
    rules.set(before, set);
  } else if (updateMatch) {
    const pages = updateMatch[0].split(",").map(Number);

    if (inOrder(pages, rules)) {
      correctMiddleSum += pages[(pages.length - 1) / 2];
    } else {
      const sortedPages = sortPages(pages, rules);
      incorrectMiddleSum += sortedPages[(sortedPages.length - 1) / 2];
    }
  }
});

// Handle errors
rl.on('error', (err) => {
  console.error('Error reading file:', err.message);
  process.exit(1);
});

// Finish reading
rl.on('close', () => {
  console.log(`Correct Middle Sum: ${correctMiddleSum}`);
  console.log(`Incorrect Middle Sum: ${incorrectMiddleSum}`);
});

function inOrder(pages: Array<number>, rules: Map<number, Set<number>>) {
  return pages.every((_, i, array) => {
    if (i === 0) return true;
    return rules.get(array[i - 1])?.has(array[i]) ?? false;
  });
}

function sortPages(pages: Array<number>, rules: Map<number, Set<number>>) {
  return pages.sort((p1, p2) => {
    if (rules.get(p1)?.has(p2)) {
      return -1;
    } else {
      return 1;
    }
  });
}