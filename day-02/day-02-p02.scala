import scala.io.Source
import scala.util.Using

@main def evaluateReports(): Unit = {
  val reports = readReports("input.txt")
  val safe_reports = reports.filter { report =>
    permutationsWithOneRemoved(report).exists(isSafeReport(_))
  }
  println(s"Number of safe reports: ${safe_reports.length}")
}

def isSafeReport(report: List[Int]): Boolean = {
  val differences = report.sliding(2).collect {
    case Seq(a, b) => b - a
  }.toList

  val allIncreasing = differences.forall((1 to 3).contains(_))
  val allDecreasing = differences.forall((-3 to -1).contains(_))

  allIncreasing || allDecreasing
}

def permutationsWithOneRemoved[A](list: List[A]): List[List[A]] = {
  list.indices.map(i => list.patch(i, Nil, 1)).toList
}

def readReports(file: String): List[List[Int]] = {
  Using.resource(Source.fromFile(file)) { source =>
    source.getLines
      .map { line =>
        line.split(' ')
          .toList
          .map(_.toInt)
      }
      .toList
  }
}
