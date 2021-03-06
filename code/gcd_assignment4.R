
packages <- c("data.table", "quantmod")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

# Week 4 Quiz


# Question 1

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
f <- file.path(getwd(), "Community_Survey.csv")
download.file(url, f)
dtCs <- data.table(read.csv(f))

strsplit(colnames(dtCs), "wgtp")

rm(dtCs)

# Question 2

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "GDP.csv")
download.file(url, f)
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 215))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", 
                                               "Long.Name", "gdp"))

gdp <- as.numeric(gsub(",", "", dtGDP$gdp))

mean(gdp, na.rm = TRUE)

# Question 3

isUnited <- grepl("^United", dtGDP$Long.Name)
summary(isUnited)


# Question 4
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f <- file.path(getwd(), "EDSTATS_Country.csv")
download.file(url, f)
dtEd <- data.table(read.csv(f))
dt <- merge(dtGDP, dtEd, all = TRUE, by = c("CountryCode"))
isFiscalYearEnd <- grepl("fiscal year end", tolower(dt$Special.Notes))
isJune <- grepl("june", tolower(dt$Special.Notes))
table(isFiscalYearEnd, isJune)

dt[isFiscalYearEnd & isJune, Special.Notes]


# Question 5

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

amzn <- getSymbols("AMZN", auto.assign = FALSE)

sampleTimes <- index(amzn)
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))