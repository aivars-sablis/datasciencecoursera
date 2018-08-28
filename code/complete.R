complete <- function(directory, id = 1:332) {
  location <- paste("/Users/admin/git/data-science-coursera/", directory, sep = "")
  data <- NULL
  for (i in seq_along(id)) {
    tmp_data <- NULL
    file <- stri_pad_left(id[i], 3, 0)
    file <- paste("/",file,".csv", sep = "")
    #data <- rbind(read.csv(paste(location,file, sep = "")), data)
    tmp_data <- read.csv(paste(location,file, sep = ""))
    cc <- sum(complete.cases(tmp_data), na.rm=TRUE)
    data <- rbind(data, data.frame("id" = id[1], "nobs" = cc))
  }
  data
}

complete("specdata", 1)
complete("specdata", c(2, 4, 8, 10, 12))
complete("specdata", 30:25)
complete("specdata", 3)
