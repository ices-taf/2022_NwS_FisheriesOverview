
# Here we run a few intermediate formatting steps done on SAG. 
# STECF and catch statistics only need one formatting step already done in data.R

library(icesTAF)
library(dplyr)
taf.library(icesFO)

mkdir("model")

#last year we modified by hand usk and cap, ask Sarah

#A. Trends by guild

clean_sag <- read.taf("data/clean_sag.csv")
trends <- stock_trends(clean_sag)
guild <- guild_trends(clean_sag)

write.taf(trends, dir = "model")
write.taf(guild, dir = "model")

#B.Trends and current catches, landings and discards

catch_trends <- CLD_trends(clean_sag)
catch_current <- stockstatus_CLD_current(clean_sag)

write.taf(catch_trends, dir = "model")
write.taf(catch_current, dir = "model")
