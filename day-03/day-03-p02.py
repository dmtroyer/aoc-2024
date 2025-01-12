import re

with open('input.txt') as f:
    read_data = f.read().replace('\n', '')

commands_pattern = re.compile(r"(do\(\)|don\'t\(\)|mul\(\d+,\d+\))")
commands = commands_pattern.findall(read_data)

total = 0
stop = False

# Process commands
for command in commands:
    match command:
        case "don't()":
            stop = True
        case "do()":
            stop = False
        case _ if not stop and command.startswith("mul("):
            # Extract numbers directly with regex
            x, y = map(int, re.match(r"mul\((\d+),(\d+)\)", command).groups())
            total += x * y

print(f"Sum of multiplications: {total}")
