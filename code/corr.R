corr <- function(directory, threshold = 0) {
  cr <- NULL
  data <- NULL
  id_data <- complete(directory)
  cases <- subset(id_data, nobs > threshold, select = id)
  
  location <- paste("/Users/admin/git/data-science-coursera/", directory, sep = "")
  if (length(cases$id) > 0) {
    length(cr) <- length(cases$id)
    for (i in seq_along(cases$id)) {
      file <- stri_pad_left(cases$id[i], 3, 0)
      file <- paste("/",file,".csv", sep = "")
      #data <- rbind(read.csv(paste(location,file, sep = "")), data)
      data <- read.csv(paste(location,file, sep = ""))
      cr[i] <- cor(data[["sulfate"]], data[["nitrate"]], use = "complete.obs")
    }
    return(cr) 
  }
  cr <- vector('numeric')
  return(cr)
}

cr <- corr("specdata", 150)
head(cr)
summary(cr)

cr <- corr("specdata", 400)
head(cr)
summary(cr)

cr <- corr("specdata", 5000)
summary(cr)
length(cr)

cr <- corr("specdata")
summary(cr)
length(cr)

cr <- corr("specdata")                
cr <- sort(cr)                
set.seed(868)                
out <- round(cr[sample(length(cr), 5)], 4)
print(out)


cr <- corr("specdata", 129)                
cr <- sort(cr)                
n <- length(cr)                
set.seed(197)                
out <- c(n, round(cr[sample(n, 5)], 4))
print(out)


cr <- corr("specdata", 2000)                
n <- length(cr)                
cr <- corr("specdata", 1000)                
cr <- sort(cr)
print(c(n, round(cr, 4)))
