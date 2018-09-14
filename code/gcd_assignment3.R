fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/community2.csv", method = "curl")
list.files("./data")
dateDownloaded <- date()

communityData <- read.table("./data/community2.csv", sep = ",", header = TRUE)

agricultureLogical <- communityData$AGS > 5
which(agricultureLogical)

img <- readJPEG("./data/getdata-jeff.jpg", native = TRUE)

quantile(img, probs = 0.30)
quantile(img, probs = 0.80)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = "./data/gdp.csv", method = "curl")
list.files("./data")
dateDownloaded <- date()

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl, destfile = "./data/educational.csv", method = "curl")
list.files("./data")
dateDownloaded <- date()

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "GDP.csv")
download.file(url, f)
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 215))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", 
                                               "Long.Name", "gdp"))
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f <- file.path(getwd(), "EDSTATS_Country.csv")
download.file(url, f)
dtEd <- data.table(read.csv(f))
dt <- merge(dtGDP, dtEd, all = TRUE, by = c("CountryCode"))
sum(!is.na(unique(dt$rankingGDP)))

dt[order(rankingGDP, decreasing = TRUE), list(CountryCode, Long.Name.x, Long.Name.y, 
                                              rankingGDP, gdp)][13]


dt[, mean(rankingGDP, na.rm = TRUE), by = Income.Group]


breaks <- quantile(dt$rankingGDP, probs = seq(0, 1, 0.2), na.rm = TRUE)
dt$quantileGDP <- cut(dt$rankingGDP, breaks = breaks)
dt[Income.Group == "Lower middle income", .N, by = c("Income.Group", "quantileGDP")]
