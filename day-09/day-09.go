package main

import (
	"fmt"
	"os"
	"unicode"
)

func getDiskLength(diskMap []int) int {
	len := 0
	for _, digit := range diskMap {
		len += digit
	}
	return len
}

func buildDisk(diskMap []int) []int {
	len := getDiskLength(diskMap)
	disk := make([]int, len)
	diskIndex := 0

	for i, blockLength := range diskMap {
		for k := 0; k < blockLength; k++ {
			if i%2 == 0 {
				disk[diskIndex] = i / 2
			} else {
				disk[diskIndex] = -1
			}
			diskIndex++
		}
	}
	return disk
}

func buildDiskMap(input string) []int {
	var diskMap []int
	for _, r := range input {
		if unicode.IsDigit(r) {
			i := int(r - '0')
			diskMap = append(diskMap, i)
		}
	}
	return diskMap
}

func compactDisk(disk []int) []int {
	j := len(disk) - 1

	for i := 0; i < j; i++ {
		if disk[i] == -1 {
			for ; j >= 0; j-- {
				if disk[j] != -1 {
					disk[i], disk[j] = disk[j], -1
					break
				}
			}
		}
	}

	return disk
}

func printDisk(disk []int) {
	for i, id := range disk {
		fmt.Printf("i: %d, id: %d\n", i, id)
	}
}

func getChecksum(disk []int) int {
	checksum := 0
	for i, id := range disk {
		if id != -1 {
			checksum += i * id
		}
	}
	return checksum
}

func main() {
	// Ensure the program was passed a file name
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run main.go <filename>")
		os.Exit(1)
	}

	// The file name is the first argument
	fileName := os.Args[1]

	// Read the file
	content, err := os.ReadFile(fileName)
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		os.Exit(1)
	}

	diskMap := buildDiskMap(string(content))
	disk := buildDisk(diskMap)
	disk = compactDisk(disk)
	checkSum := getChecksum(disk)

	fmt.Printf("Checksum: %d\n", checkSum)
}
