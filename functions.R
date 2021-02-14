library(SqlRender)

#' Split A Single SQL String Into One Or More SQL Statements
#'
#' @param statement String
#'
#' @return "array"
#' @export
#'
#' @examples
#' split("SELECT * FROM departments; USE sales; DROP TABLE revenue;")
#' Result | "SELECT * FROM departments", "USE sales", "DROP TABLE revenue"
split <- function(statement) {
  list(statements = splitSql(statement))
}
