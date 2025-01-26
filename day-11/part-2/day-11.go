package main

import (
	"container/list"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func buildStoneMap(stoneString string) (map[int]int, error) {
	stoneSlice := strings.Fields(stoneString)
	stoneMap := make(map[int]int)

	for _, s := range stoneSlice {
		number, err := strconv.Atoi(s)
		handleError(err)
		stoneMap[number]++
	}

	return stoneMap, nil
}

func handleError(err error) {
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
	return
}

func numberOfDigitsIsEven(number int) bool {
	return len(strconv.Itoa(number))%2 == 0
}

func printStones(stones *list.List) {
	for e := stones.Front(); e != nil; e = e.Next() {
		fmt.Printf("%d", e.Value)
		if e.Next() == nil {
			fmt.Print("\n\n")
		} else {
			fmt.Print(" ")
		}
	}
}

func splitInteger(number int) (int, int) {
	intString := strconv.Itoa(number)
	mid := len(intString) / 2
	firstHalf, _ := strconv.Atoi(intString[:mid])
	secondHalf, _ := strconv.Atoi(intString[mid:])

	return firstHalf, secondHalf
}

func readStoneFile(fileName string) (string, error) {
	data, err := os.ReadFile(fileName)
	if err != nil {
		return "", fmt.Errorf("error reading file %s: %w", fileName, err)
	}
	return string(data), nil
}

func main() {
	// Ensure the program was passed a file name
	if len(os.Args) < 3 {
		fmt.Println("Usage: go run day-11.go <filename> <numBlinks>")
		os.Exit(1)
	}

	// The file name is the first argument
	fileName := os.Args[1]
	numBlinks, err := strconv.Atoi(os.Args[2])
	handleError(err)

	// Read the file
	stoneString, err := readStoneFile(fileName)
	handleError(err)

	stoneMap, err := buildStoneMap(stoneString)
	handleError(err)

	for i := 0; i < numBlinks; i++ {
		newStoneMap := make(map[int]int)
		for stone, count := range stoneMap {
			if stone == 0 {
				newStoneMap[1] += count
			} else if numberOfDigitsIsEven(stone) {
				leftStone, rightStone := splitInteger(stone)
				newStoneMap[leftStone] += count
				newStoneMap[rightStone] += count
			} else {
				newStoneMap[stone*2024] += count
			}
		}
		stoneMap = newStoneMap
	}

	sum := 0
	for _, count := range stoneMap {
		sum += count
	}

	fmt.Printf("Number of stones found: %d\n", sum)
}
