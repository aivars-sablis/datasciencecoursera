library(stringi)

pollutantmean <- function(directory, pollutant, id = 1:332) {
  #setwd("/Users/admin/git/data-scienece-coursera")
  location <- paste("/Users/admin/git/data-science-coursera/", directory, sep = "")
  data <- NULL
  for (i in seq_along(id)) {
    file <- stri_pad_left(id[i], 3, 0)
    file <- paste("/",file,".csv", sep = "")
    data <- rbind(read.csv(paste(location,file, sep = "")), data)
  }
  
  #pollutant_data <- data[pollutant]
  #bad <- is.na(data[pollutant])
  #mean <- mean(pollutant_data[!bad])
  mean(data[[pollutant]], na.rm = TRUE)
}

pollutantmean("specdata", "sulfate", 1:10)
pollutantmean("specdata", "nitrate", 70:72)
pollutantmean("specdata", "sulfate", 34)
pollutantmean("specdata", "nitrate")
