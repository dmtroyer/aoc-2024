import scala.io.Source
import scala.util.Using

var gridDimensions: (Int, Int) = (0, 0)
var grid: List[List[Char]] = List()

@main def evalXmas(): Unit = {
  grid = readGrid("input.txt")
  gridDimensions = (grid.head.size, grid.size)

  val count = (for {
    x <- 1 until gridDimensions._1 - 1
    y <- 1 until gridDimensions._2 - 1
    if isXmas(x, y)
  } yield 1).size

  println(s"Count: ${count}")
}

def isXmas(x: Int, y: Int): Boolean = {
  if (grid(y)(x) != 'A') return false

  val nwCross = Seq(grid(y - 1)(x - 1), grid(y)(x), grid(y + 1)(x + 1)).mkString
  val neCross = Seq(grid(y - 1)(x + 1), grid(y)(x), grid(y + 1)(x - 1)).mkString

  // Validate patterns
  Set("MAS", "SAM").contains(nwCross) && Set("MAS", "SAM").contains(neCross)
}

def readGrid(file: String): List[List[Char]] = {
  Using.resource(Source.fromFile(file))(_.getLines().map(_.toList).toList)
}
