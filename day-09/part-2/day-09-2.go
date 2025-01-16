package main

import (
	"container/list"
	"fmt"
	"os"
	"unicode"
)

type diskFile struct {
	id, len int
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

func buildDisk(diskMap []int) *list.List {
	disk := list.New()
	for i, blockLength := range diskMap {
		blockId := -1
		if i%2 == 0 {
			blockId = i / 2
		}
		disk.PushBack(diskFile{id: blockId, len: blockLength})
	}
	return disk
}

func compactDisk(disk *list.List) *list.List {
	// Go back to front over the disk looking for files that can fit as far to the
	// front of the disk as possible
	for j := disk.Back(); j != disk.Front(); j = j.Prev() {
		if bj, ok := j.Value.(diskFile); ok && bj.id > -1 {
			// Start from the front of the disk looking for an empty space large enough
			// for the current file
			for i := disk.Front(); i != j; i = i.Next() {
				if bi, ok := i.Value.(diskFile); ok && bi.id == -1 && bi.len >= bj.len {
					rem := bi.len - bj.len
					i.Value = diskFile{id: bj.id, len: bj.len}
					j.Value = diskFile{id: -1, len: bj.len}
					if rem > 0 {
						disk.InsertAfter(diskFile{id: -1, len: rem}, i)
					}
					break
				}
			}
		}
	}
	return disk
}

func getChecksum(disk *list.List) int {
	checksum := 0
	i := 0

	for e := disk.Front(); e != nil; e = e.Next() {
		if b, ok := e.Value.(diskFile); ok {
			j := i + b.len
			for ; i < j; i++ {
				if b.id > -1 {
					checksum += i * b.id
				}
			}
		} else {
			fmt.Println("Value is not a block")
			break
		}
	}
	return checksum
}

func printDisk(disk *list.List) {
	fmt.Print("Disk: ")

	for i := disk.Front(); i != nil; i = i.Next() {
		if bi, ok := i.Value.(diskFile); ok {
			for j := 0; j < bi.len; j++ {
				if bi.id == -1 {
					fmt.Print(".")
				} else {
					fmt.Printf("%d", bi.id)
				}
			}
		}
	}

	fmt.Print("\n")
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

	// printDisk(disk)
	fmt.Printf("Checksum: %d\n", checkSum)
}
