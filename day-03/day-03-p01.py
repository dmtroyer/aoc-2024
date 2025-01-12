import re

with open('input.txt') as f:
    read_data = f.read()

pattern = re.compile(r'mul\((\d+),(\d+)\)')
matches = [(int(a), int(b)) for (a, b) in pattern.findall(read_data)]
sum = sum(a * b for (a, b) in matches)

print(f"Sum of multiplications: {sum}")
