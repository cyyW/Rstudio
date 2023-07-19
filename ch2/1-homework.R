data(iris)

input <- iris[, 1:4]
input <- head(input, 5)
input

SummarizeData <- function(x) {
  output <- data.frame(
    mean = apply(x, 2, mean),
    var = apply(x, 2, var),
    max = apply(x, 2, max),
    min = apply(x, 2, min)
  )
  output <- t(output)
  return(output)
}

output <- SummarizeData(input)
print(output)
