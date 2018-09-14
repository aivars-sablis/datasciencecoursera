if (!file.exists("data")) {
  dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/community.csv", method = "curl")
list.files("./data")

dateDownloaded <- date()

communityData <- read.table("./data/community.csv", sep = ",", header = TRUE)
head(communityData)

val <- communityData[["VAL"]]
table(val)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./data/natural-gas.xlsx", method = "curl")
list.files("./data")
dateDownloaded <- date()

install.packages("xlsx", type='source')
install.packages("rJava", type='source')
library(xlsx)

library(XML)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
download.file(fileUrl, destfile = "./data/restaurants.xml", method = "curl")
list.files("./data")
doc <- xmlTreeParse("./data/restaurants.xml", useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
zipcode <- xpathSApply(rootNode,"//zipcode", xmlValue)
table(zipcode)


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/pid.csv", method = "curl")

library(data.table)
DT <- fread("./data/pid.csv")
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(rowMeans(DT)[DT$SEX==1], rowMeans(DT)[DT$SEX==2])
system.time(mean(DT[DT$SEX==1,]$pwgtp15), mean(DT[DT$SEX==2,]$pwgtp15))
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))



