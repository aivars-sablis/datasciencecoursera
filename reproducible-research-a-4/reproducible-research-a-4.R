packages <- c("data.table")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

#set working directory
setwd("/Users/admin/git/data-science-coursera/reproducible-research-a-4")
path <- getwd()

# Get the data
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
bz2 <- "StormData.bz2"
if (!file.exists(path)) {
    dir.create(path)
}
download.file(url, file.path(path, bz2))


f <- "activity.csv"
stormDataDf <- read.csv(file.path(path, bz2))

activityDt <- read.table(unz(file.path(path, zip), f), sep = ",", header = TRUE)

tmpdf <- stormDataDf %>% 
    select(EVTYPE, FATALITIES, INJURIES) %>% 
    group_by(EVTYPE) %>% 
    summarize(total_f = sum(FATALITIES), total_i = sum(INJURIES)) %>% 
    arrange(desc(total_f)) 

tmpdf10 <- tmpdf[1:10,]

g <- ggplot(data = tmpdf10, aes(x = reorder(EVTYPE, total), y = total, fill = total)) +
    geom_bar(stat="identity") +
    scale_fill_continuous(low="steelblue", high="black") +
    geom_text(aes(label = total), hjust=-0.2, size=3.5, family = "Times") +
    scale_y_continuous(limits = c(0,ceiling(tmpdf10[1,]$total/1000)*1000)) + 
    coord_flip() + 
    xlab("Event Type") + 
    ylab("Total number of deaths per event") + 
    labs(fill = "Deaths") + 
    theme_minimal(base_family = "Times")

g


g <- ggplot(data = tmpdf10, aes(x = reorder(EVTYPE, total), y = total, fill = total)) +
    geom_bar(stat="identity") +
    scale_fill_continuous(low="steelblue", high="black") +
    geom_text(aes(label = total), hjust=-0.1, size=3.5) +
    scale_y_continuous(limits = c(0,ceiling(tmpdf10[1,]$total/1000)*1000)) + 
    coord_flip() + 
    xlab("Event Type") + 
    ylab("Total deaths") + 
    theme_minimal(base_family = "Times")


us <- map_data("state")

arr <- USArrests %>% 
    add_rownames("region") %>% 
    mutate(region=tolower(region))

gg <- ggplot()
gg <- gg + geom_map(data=us, map=us,
                    aes(x=long, y=lat, map_id=region),
                    fill="#ffffff", color="#ffffff", size=0.15)
gg <- gg + geom_map(data=arr, map=us,
                    aes(fill=Murder, map_id=region),
                    color="#ffffff", size=0.15)
gg <- gg + scale_fill_continuous(low='thistle2', high='darkred', 
                                 guide='colorbar')
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + coord_map("albers", lat0 = 39, lat1 = 45) 
gg <- gg + theme(panel.border = element_blank())
gg <- gg + theme(panel.background = element_blank())
gg <- gg + theme(axis.ticks = element_blank())
gg <- gg + theme(axis.text = element_blank())
gg
