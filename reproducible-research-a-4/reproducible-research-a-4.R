Sys.setenv(TZ="Europe/Stockholm")
packages <- c("data.table", "tidyverse", "reshape2", "ggplo2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

#set working directory
setwd("/Users/admin/git/data-science-coursera/reproducible-research-a-4")
path <- getwd()

# Load the data
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
data_path <- paste(path, "/data/", sep = "")
bz2 <- "StormData.bz2"
if (!file.exists(data_path)) {
    dir.create(data_path)
}
if (!file.exists(file.path(data_path, bz2))) {
    download.file(url, file.path(data_path, bz2))
}

f <- "activity.csv"
stormDataDf <- read.csv(file.path(data_path, bz2))


tmpdf <- stormDataDf %>% 
    select(EVTYPE, FATALITIES, INJURIES) %>% 
    group_by(EVTYPE) %>% 
    summarize(total_f = sum(FATALITIES), total_i = sum(INJURIES)) %>% 
    arrange(desc(total_f)) 
top_fatalities_df10 <- tmpdf[1:10,]

# plot data
plot_fatalities <- ggplot(data = top_fatalities_df10, 
                          aes(x = reorder(EVTYPE, total_f), y = total_f, fill = total_f))
# adjust aesthetics
plot_fatalities <- plot_fatalities + geom_bar(stat="identity") +
    scale_fill_continuous(low="steelblue", high="black") +
    geom_text(aes(label = total_f), hjust=-0.2, size=3.5, family = "Times") +
    scale_y_continuous(limits = c(0,ceiling(top_fatalities_df10[1,]$total_f/1000)*1000)) + 
    coord_flip() + 
    xlab("Event Type") + 
    ylab("Total number of fatalities per event") + 
    labs(fill = "Fatalities") + 
    theme_minimal(base_family = "Times")
plot_fatalities

tmpdf <- tmpdf %>% 
    arrange(desc(total_i)) 
top_injuries_df10 <- tmpdf[1:10,]
    
plot_injuries <- ggplot(data = top_injuries_df10, aes(x = reorder(EVTYPE, total_i), y = total_i, fill = total_i))
plot_injuries <- plot_injuries + geom_bar(stat="identity") +
    scale_fill_continuous(low="pink", high="red") +
    geom_text(aes(label = total_i), hjust=-0.2, size=3.5, family = "Times") +
    scale_y_continuous(limits = c(0,ceiling(top_injuries_df10[1,]$total_i/10000)*10000)) + 
    coord_flip() + 
    xlab("Event Type") + 
    ylab("Total number of injuries per event") + 
    labs(fill = "Injuries") + 
    theme_minimal(base_family = "Times")

plot_injuries

##Filter the subset so that either variable must have a value greater than zero. 
damage_df <- stormDataDf %>% 
    select(EVTYPE, CROPDMG, PROPDMG, PROPDMGEXP, CROPDMGEXP) %>% 
    filter(PROPDMG > 0 | CROPDMG > 0)

##Convert property damage values to a single unit, "dollars"
damage_df[damage_df$PROPDMGEXP == "H", ]$PROPDMG = damage_df[damage_df$PROPDMGEXP == "H", ]$PROPDMG * 10^2
damage_df[damage_df$PROPDMGEXP == "K", ]$PROPDMG = damage_df[damage_df$PROPDMGEXP == "K", ]$PROPDMG * 10^3
damage_df[damage_df$PROPDMGEXP == "M", ]$PROPDMG = damage_df[damage_df$PROPDMGEXP == "M", ]$PROPDMG * 10^6
damage_df[damage_df$PROPDMGEXP == "B", ]$PROPDMG = damage_df[damage_df$PROPDMGEXP == "B", ]$PROPDMG * 10^9
##Convert crop damage values to a single unit, "dollars".
damage_df[damage_df$CROPDMGEXP == "H", ]$CROPDMG = damage_df[damage_df$CROPDMGEXP == "H", ]$CROPDMG * 10^2
damage_df[damage_df$CROPDMGEXP == "K", ]$CROPDMG = damage_df[damage_df$CROPDMGEXP == "K", ]$CROPDMG * 10^3
damage_df[damage_df$CROPDMGEXP == "M", ]$CROPDMG = damage_df[damage_df$CROPDMGEXP == "M", ]$CROPDMG * 10^6
damage_df[damage_df$CROPDMGEXP == "B", ]$CROPDMG = damage_df[damage_df$CROPDMGEXP == "B", ]$CROPDMG * 10^9

# group data and summarize by event
damage_df <- damage_df %>% 
    group_by(EVTYPE) %>% 
    summarize(Crop = sum(CROPDMG)/10^3, Property = sum(PROPDMG)/10^3, total_t = (sum(CROPDMG)+sum(PROPDMG))/10^3) %>% 
    arrange(desc(total_t)) 

top_damage_df10 <- damage_df[1:10,"EVTYPE"]

damage_df <- damage_df %>% 
    filter(EVTYPE %in% top_damage_df10$EVTYPE)

mdata <- melt(damage_df, id=c("EVTYPE", "total_t"))

pplot_damage <- ggplot(mdata, 
                       aes(x = reorder(EVTYPE, total_t), y = value, fill = variable, 
                           label = round(value/10^6, digits = 2))) +
    geom_bar(stat = "identity", position = "stack")

pplot_damage <- pplot_damage + coord_flip() + 
    scale_y_continuous(limits = c(0,ceiling(mdata[1,]$total_t/10^6)*10^6+20)) + 
    geom_text(size = 3, position = position_stack(vjust = 0.5), hjust=-.25, family = "Times") + 
    xlab("Event Type") + 
    ylab("Total damage (in millions USD)") + 
    labs(fill = "Type of\ndamage") + 
    theme_minimal(base_family = "Times")
pplot_damage

top_damage_df10 <- tmpdf[1:10,]

top_damage_df10 <- mdata

plot_damage <- ggplot(data = top_damage_df10, aes(x = reorder(EVTYPE, total_t), y = value, fill = variable))
plot_damage <- plot_damage + geom_bar(stat="identity", position=position_dodge()) +
    coord_flip() + 
    scale_y_continuous(limits = c(0,ceiling(top_damage_df10[1,]$total_t/10000)*10000-5000)) + 
    geom_text(aes(label = value), hjust=-.2, vjust=.2, size=3, family = "Times") +
    xlab("Event Type") + 
    ylab("Total damage (in millions USD)") + 
    labs(fill = "Type of\ndamage") + 
    theme_minimal(base_family = "Times")
 
plot_damage

scale_fill_discrete(breaks=c("Property", "Crop")) +

+
    scale_fill_continuous(low="pink", high="red") +
    geom_text(aes(label = total_t), hjust=-0.2, size=3.5, family = "Times") +
    scale_y_continuous(limits = c(0,ceiling(top_damage_df10[1,]$total_i/10000)*10000)) + 
    coord_flip() + 

plot_damage



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



tmpdf_s <- stormDataDf %>% 
    select(EVTYPE, FATALITIES, INJURIES, STATE) %>% s
    group_by(STATE) %>% 
    summarize(total_f = sum(FATALITIES), total_i = sum(INJURIES)) %>% 
    arrange(desc(total_f)) %>% 
    mutate(STATE=tolower(state.name[match(STATE,state.abb)])) %>% 
    na.omit()

gg <- ggplot()
gg <- gg + geom_map(data=us, map=us,
                    aes(x=long, y=lat, map_id=region),
                    fill="#ffffff", color="#ffffff", size=0.15) 
gg <- gg + geom_map(data=tmpdf_s, map=us,
                    aes(fill=total_f, map_id=STATE),
                    color="#ffffff", size=0.15)
gg <- gg + scale_fill_continuous(low='thistle2', high='darkred', 
                                 guide='colorbar')
#gg <- gg + geom_text(data=us, aes(long, lat, label = region),
#          color = "blue", size=3)
gg <- gg + labs(x=NULL, y=NULL, fill = "Deaths")
gg <- gg + coord_map("albers", lat0 = 39, lat1 = 45) 
gg <- gg + theme(panel.border = element_blank())
gg <- gg + theme(panel.background = element_blank())
gg <- gg + theme(axis.ticks = element_blank())
gg <- gg + theme(axis.text = element_blank()) 
gg

write.csv(tmpdf_s, file = "state.csv", row.names=FALSE)







##Group the data by event type and sum the amounts of fatalities and injuries.
geconomic <- feconomic[, c(1, 2, 4)]
geconomic <- data.table(geconomic) %>% group_by(event_type) %>% summarise_all(funs(sum))
