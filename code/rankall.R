rankall <- function(outcome, num = "best") {
  ## Read outcome data
  data <- NULL
  best <- NULL
  hospital <- NULL
  data <- read.csv("assign-3-data/outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  is_outcome <- outcome %in% c("heart attack", "heart failure", "pneumonia")
  if (!is_outcome) {
    stop("invalid outcome")
  }
  
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
  
  data <- data[order( data["State"]), ]
  
  ## Check that state and outcome are valid
  ## For each state, find the hospital of the given rank
  state <- unique(data[["State"]])
  for (i in seq_along(state)) {
    
    #tmp_data <- subset(data, data["State"] == "WY")
    
    tmp_data <- subset(data, data["State"] == state[i])
    tmp_data <- tmp_data[order( tmp_data[,2] ),]
    
    tmp_data <- tmp_data[, c(2, col_num)]
    tmp_data <- subset(tmp_data, tmp_data[, 2] != "Not Available")
    
    tmp_data[, 2] <- as.numeric(tmp_data[, 2] )
    tmp_data <- tmp_data[order( tmp_data[, 2] ),]
    
    tmp_data$Rank <- NA 
    tmp_data$Rank <- rank(tmp_data[, 2], ties.method= "first")
    
    if (num == "best") {
      num_x <- 1
    } else if (num == "worst") {
      num_x <- nrow(tmp_data)
    }
    if (num_x > nrow(tmp_data)) {
      hospital[i] <- NA
    } else {
      hospital[i] <- tmp_data[num_x, "Hospital.Name"]
    }
  }
  
  best <- data.frame(hospital, state)
  best
}

head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)