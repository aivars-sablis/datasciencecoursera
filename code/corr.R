corr <- function(directory, threshold = 0) {
  data <- complete(directory)
  
  cases <- data[[nobs > 150]] > 150
  
  cases
  
}

cr <- corr("specdata", 150)
head(cr)