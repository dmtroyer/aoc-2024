package main

import (
	"container/list"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func buildStoneList(stoneString string) (*list.List, error) {
	stoneSlice := strings.Fields(stoneString)
	stoneList := list.New()

	for _, s := range stoneSlice {
		number, err := strconv.Atoi(s)
		if err != nil {
			return nil, fmt.Errorf("failed to parse '%s' as an integer: %w", s, err)
		}
		stoneList.PushBack(number)
	}

	return stoneList, nil
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

	stoneList, err := buildStoneList(stoneString)
	handleError(err)

	numStones := stoneList.Len()
	for i := 0; i < numBlinks; i++ {
		for e := stoneList.Front(); e != nil; e = e.Next() {
			if e.Value.(int) == 0 {
				e.Value = 1
			} else if numberOfDigitsIsEven(e.Value.(int)) {
				leftStone, rightStone := splitInteger(e.Value.(int))
				e.Value = leftStone
				stoneList.InsertAfter(rightStone, e)
				e = e.Next()
			} else {
				e.Value = e.Value.(int) * 2024
			}
		}

		newNumStones := stoneList.Len()
		fmt.Printf("Stones after %d blinks: %d, diff: %d\n", i+1, newNumStones, newNumStones-numStones)
		printStones(stoneList)

		numStones = newNumStones
	}
}
