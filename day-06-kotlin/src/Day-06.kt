import java.io.File

enum class Direction {
    NORTH, EAST, SOUTH, WEST;

    fun next(): Direction {
        return entries[(ordinal + 1) % entries.size]
    }
}

data class Position(val x: Int, val y: Int, val isWall: Boolean = false) {
    override fun toString(): String = "($x, $y, wall=$isWall)"

    override fun equals(other: Any?): Boolean {
        // Check if 'other' is an instance of Position
        if (this === other) return true // Reference equality check
        if (other !is Position) return false // Type check

        // Compare only x and y (ignoring isWall)
        return this.x == other.x && this.y == other.y
    }

    override fun hashCode(): Int {
        // Hash only x and y since isWall is ignored in equals
        return 31 * x + y
    }
}

class Guard(initialPosition: Position, var orientation: Direction) {
    val visitedPositions: MutableSet<Pair<Position, Direction>> = mutableSetOf(Pair(initialPosition, orientation))

    var currentPosition: Position = initialPosition
        private set

    fun copy(): Guard {
        val newGuard = Guard(currentPosition, orientation)
        newGuard.visitedPositions.addAll(this.visitedPositions)
        return newGuard
    }

    fun next(): Position {
        return when(orientation) {
            Direction.NORTH -> Position(x = currentPosition.x, y = currentPosition.y - 1)
            Direction.EAST -> Position(x = currentPosition.x + 1, y = currentPosition.y)
            Direction.SOUTH -> Position(x = currentPosition.x, y = currentPosition.y + 1)
            Direction.WEST -> Position(x = currentPosition.x - 1, y = currentPosition.y)
        }
    }

    fun turn() {
        this.orientation = this.orientation.next()
    }

    fun visit(position: Position) {
        currentPosition = position
        visitedPositions.add(Pair(position, orientation))
    }

    fun visitNext() {
        visit(this.next())
    }
}

class GameMap(val positions: MutableSet<Position> = mutableSetOf()) {
    val wallPositions: MutableSet<Position> = mutableSetOf()

    fun contains(position: Position): Boolean {
        return positions.contains(position)
    }

    fun isWall(position: Position): Boolean {
        return wallPositions.contains(position) // O(1) check
    }
}

object MapParser {
    fun parse(input: String, createGuard: (Position, Direction) -> Guard): Pair<GameMap, Guard> {
        val map = GameMap()
        var guard: Guard? = null
        var x = 0
        var y = 0

        for (char in input) {
            when (char) {
                '\n' -> {
                    x = 0
                    y++
                }
                '^', '>', 'v', '<' -> {
                    val pos = Position(x, y)
                    guard = createGuard(pos, charToDirection(char))
                    map.positions.add(pos)
                    x++
                }
                '#' -> {
                    map.positions.add(Position(x, y, isWall = true))
                    map.wallPositions.add(Position(x, y, isWall = true))
                    x++
                }
                else -> {
                    map.positions.add(Position(x, y))
                    x++
                }
            }
        }

        return Pair(map, guard ?: throw IllegalArgumentException("No guard found"))
    }

    private fun charToDirection(ch: Char): Direction {
        return mapOf(
            '^' to Direction.NORTH,
            'v' to Direction.SOUTH,
            '<' to Direction.WEST,
            '>' to Direction.EAST
        )[ch] ?: throw IllegalArgumentException("Invalid direction: $ch")
    }
}

fun main(args: Array<String>) {
    // Read the input file
    val mapString = File(args[0]).readText()

    // Parse the map and guard
    val (map, guard) = MapParser.parse(mapString) { pos, dir -> Guard(pos, dir) }

    val visitedPositions = partOne(map, guard.copy())
    partTwo(map, guard.copy(), visitedPositions)
}

fun partOne(map: GameMap, guard: Guard): Set<Position> {
    while (map.contains(guard.next())) {
        val nextPosition = map.positions.find { it == guard.next() }

        if (nextPosition?.isWall == true) {
            guard.turn()
        } else {
            guard.visitNext()
        }
    }

    println("Visited positions: ${guard.visitedPositions.size}")
    return guard.visitedPositions.map { it.first }.toSet()
}

fun partTwo(map: GameMap, guard: Guard, positions: Set<Position>) {
    var blockers = 0

    positions.forEach { position ->
        val simGuard = guard.copy()

        if (!(simGuard.currentPosition == position || map.isWall(position))) {
            while (true) {
                val nextPosition = simGuard.next()

                if (nextPosition == position || map.isWall(nextPosition)) {
                    simGuard.turn()
                } else if (simGuard.visitedPositions.contains(Pair(nextPosition, simGuard.orientation))) {
                    blockers++
                    break
                } else if (!map.contains(nextPosition)) {
                    break
                } else {
                    simGuard.visitNext()
                }
            }
        }
    }

    println("Blockers: $blockers")
}