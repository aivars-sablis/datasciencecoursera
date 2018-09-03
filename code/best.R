setwd("/Users/admin/git/data-science-coursera/")
outcome <- read.csv("assign-3-data/outcome-of-care-measures.csv", colClasses = "character")
head(outcome)

ncol(outcome)
nrow(outcome)
names(outcome)

outcome[, 11] <- as.numeric(outcome[, 11])

hist(outcome[, 11])

best <- function(state, outcome) {
  ## Read outcome data
  data <- NULL
  data <- read.csv("assign-3-data/outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  is_outcome <- outcome %in% c("heart attack", "heart failure", "pneumonia")
  if (!is_outcome) {
    stop("invalid outcome")
  }
  is_state <- state %in% unique(data[["State"]])
  if (!is_state) {
    stop("invalid state")
  }
  
  data <- subset(data, data["State"] == state)
  data <- data[order( data[,2] ),]
  
  
  ## heart attack
  if (outcome == "heart attack") {
    col_num <- 11
  }
  ## heart failure
  if (outcome == "heart failure") {
    col_num <- 17
  }
  ## pneumonia
  if (outcome == "pneumonia") {
    col_num <- 23
  }

  data[, col_num] <- as.numeric(data[, col_num] )
  data <- data[order( data[, col_num] ),]
  best <- data[1,"Hospital.Name"]

  best
}

state <- "TX"
outcome <- "heart failure"

best("TX", "heart attack")
best("TX", "heart failure")
best("MD", "heart attack")
best("MD", "pneumonia")
best("BB", "heart attack")
best("NY", "hert attack")
