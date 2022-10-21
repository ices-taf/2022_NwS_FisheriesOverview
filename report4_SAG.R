
library(icesTAF)
library(icesFO)
library(sf)
library(ggplot2)
library(dplyr)

## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2022
year_cap <- 2022
cap_month <- "October"
ecoreg_code <- "NwS"
ecoreg <- "NwS"

##########
#Load data
##########

trends <- read.taf("model/trends.csv")
catch_current <- read.taf("model/catch_current.csv")
catch_trends <- read.taf("model/catch_trends.csv")

clean_status <- read.taf("data/clean_status.csv")

#set year and month for captions:
# cap_month = "October"
# cap_year = "2020"
# # set year for plot calculations

year = 2022


###########
## 3: SAG #
###########

#~~~~~~~~~~~~~~~#
# A. Trends by guild
#~~~~~~~~~~~~~~~#

unique(trends$FisheriesGuild)

names(clean_sag)
# test <- trends %>% filter(StockKeyLabel == "reg.27.1-2")

# 1. Demersal
#~~~~~~~~~~~
plot_stock_trends(trends, guild="demersal", cap_year, cap_month , return_data = FALSE)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_demersal", ext = "png", dir = "report"), width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="demersal", cap_year , cap_month, return_data = TRUE)
write.taf(dat, file= paste0(year_cap, "_", ecoreg,"SAG_Trends_demersal.csv"), dir = "report")

# 2. Pelagic
#~~~~~~~~~~~
plot_stock_trends(trends, guild="pelagic", cap_year, cap_month , return_data = FALSE)
trends2 <- trends %>% filter(StockKeyLabel != "bsf.27.nea")
plot_stock_trends(trends2, guild="pelagic", cap_year, cap_month , return_data = FALSE)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_pelagic", ext = "png", dir = "report"), width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="pelagic", cap_year, cap_month, return_data = TRUE)
write.taf(dat,file= paste0(year_cap, "_", ecoreg,"SAG_Trends_pelagic.csv"), dir = "report")

# 3. Elasmobranchs
#~~~~~~~~~~~
plot_stock_trends(trends, guild="elasmobranch", cap_year, cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_elasmobranch", ext = "png", dir = "report"), width = 178, height = 130, units = "mm", dpi = 300)

# trends2 <- trends %>% dplyr::filter(Year > 1980)
# plot_stock_trends(trends2, guild="elasmobranch", cap_year, cap_month, return_data = FALSE)
# ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_FO_SAG_Trends_elasmobranch_from1980.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


dat <- plot_stock_trends(trends, guild="elasmobranch", cap_year , cap_month , return_data = TRUE)
write.taf(dat, file= paste0(year_cap, "_", ecoreg,"SAG_Trends_elasmobranch.csv"), dir = "report" )


#~~~~~~~~~~~~~~~~~~~~~~~~~#
# Ecosystem Overviews plot
#~~~~~~~~~~~~~~~~~~~~~~~~~#
guild <- read.taf("model/guild.csv")
trends <- read.taf("model/trends.csv")

# For this EO, they need separate plots with all info
# They only want whb, her and mac

trends2 <- trends%>% filter (StockKeyLabel %in% c("whb.27.1-91214",
                                                  "her.27.1-24a514a",
                                                  "mac.27.nea"))
trends2 <- trends2 [,-1]
colnames(trends2) <- c("FisheriesGuild", "Year", "Metric", "Value")
trends3 <- trends2%>% filter(Metric == "F_FMSY")
# guild2 <- guild %>% filter(Metric == "F_FMSY")
plot_guild_trends(trends3, cap_year, cap_month,return_data = FALSE )
# guild2 <- guild2 %>% filter(FisheriesGuild != "MEAN")
# plot_guild_trends(guild2, cap_year , cap_month,return_data = FALSE )
ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_F.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave("2019_BtS_EO_GuildTrends_noMEAN_F.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


trends3 <- trends2%>% filter(Metric == "SSB_MSYBtrigger")

# guild2 <- guild %>% filter(Metric == "SSB_MSYBtrigger")
# guild3 <- guild2 %>% dplyr::filter(FisheriesGuild != "MEAN")
trends3 <- trends3 %>% filter(Year > 1960)
plot_guild_trends(trends3, cap_year, cap_month,return_data = FALSE )
ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_SSB_1960.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_SSB_1900.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_guild_trends(trends2, cap_year, cap_month ,return_data = TRUE)
write.taf(dat, file =paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends.csv"), dir = "report" )

dat <- trends2[,1:2]
dat <- unique(dat)
dat <- dat %>% filter(StockKeyLabel != "MEAN")
dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
dat <- left_join(dat,dat2)
write.taf(dat, file =paste0(year_cap, "_", ecoreg, "_EO_SAG_SpeciesGuildList.csv"), dir = "report", quote = TRUE )

#~~~~~~~~~~~~~~~#
# B.Current catches
#~~~~~~~~~~~~~~~#

#Stocks assessed outside ICES
catch_current2 <- catch_current %>% filter(StockKeyLabel != "cod.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "had.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "cap.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "ghl.27.1-2")
catch_current2 <- catch_current2 %>% filter(StockKeyLabel != "reb.27.1-2")

# catch_current$Status[which(catch_current$StockKeyLabel == "cod.27.1-2")] <- "GREY" 
# catch_current$Status[which(catch_current$StockKeyLabel == "had.27.1-2")] <- "GREY"  
# catch_current$Status[which(catch_current$StockKeyLabel == "cap.27.1-2")] <- "GREY"  
# catch_current$Status[which(catch_current$StockKeyLabel == "ghl.27.1-2")] <- "GREY"  
# catch_current$Status[which(catch_current$StockKeyLabel == "reb.27.1-2")] <- "GREY"  



# 1. Demersal
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current2, guild = "demersal", caption = TRUE, cap_year, cap_month, return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current2, guild = "demersal", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =paste0(year_cap, "_", ecoreg, "SAG_Current_demersal.csv"), dir = "report" )

kobe <- plot_kobe(catch_current2, guild = "demersal", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#kobe_dat is just like bar_dat with one less variable
#kobe_dat <- plot_kobe(catch_current, guild = "Demersal", caption = T, cap_year , cap_month , return_data = TRUE)

#Check this file name
png(file_name(cap_year,ecoreg_code,"SAG_Current_demersal", ext = "png",dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "demersal")
dev.off()

# 2. Pelagic
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current2, guild = "pelagic", caption = TRUE, cap_year, cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current2, guild = "pelagic", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file =paste0(year_cap, "_", ecoreg, "SAG_Current_pelagic.csv"), dir = "report")

# catch_current <- unique(catch_current)
kobe <- plot_kobe(catch_current2, guild = "pelagic", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#check this file name
png(file_name(cap_year,ecoreg_code,"SAG_Current_pelagic", ext = "png", dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "pelagic")
dev.off()


# 3. All
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current2, guild = "All", caption = TRUE, cap_year , cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current2, guild = "All", caption = TRUE, cap_year, cap_month , return_data = TRUE)
write.taf(bar_dat, file =paste0(year_cap, "_", ecoreg, "SAG_Current_all.csv"), dir = "report" )

top_10 <- bar_dat %>% top_n(10, total)
bar <- plot_CLD_bar(top_10, guild = "All", caption = TRUE, cap_year , cap_month , return_data = FALSE)

kobe <- plot_kobe(top_10, guild = "All", caption = TRUE, cap_year, cap_month , return_data = FALSE)
#check this file name
png(file_name(cap_year,ecoreg_code,"SAG_Current_All", ext = "png", dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "All stocks top 10")
dev.off()


#~~~~~~~~~~~~~~~#

#~~~~~~~~~~~~~~~#
#C. ICES pies
#~~~~~~~~~~~~~~~#

unique(clean_status$StockKeyLabel)

clean_status2 <- clean_status %>% filter(StockKeyLabel != "cod.27.1-2")
clean_status2 <- clean_status2 %>% filter(StockKeyLabel != "had.27.1-2")
clean_status2 <- clean_status2 %>% filter(StockKeyLabel != "cap.27.1-2")
clean_status2 <- clean_status2 %>% filter(StockKeyLabel != "ghl.27.1-2")
clean_status2 <- clean_status2 %>% filter(StockKeyLabel != "reb.27.1-2")



plot_status_prop_pies(clean_status2, cap_month, cap_year)

unique(clean_status2$StockSize)
clean_status2$StockSize <- gsub("qual_RED", "RED", clean_status2$StockSize)

unique(clean_status2$FishingPressure)
# clean_status2$FishingPressure <- gsub("qual_GREEN", "GREEN", clean_status2$FishingPressure)

# clean_status2 <- clean_status
# clean_status2$FishingPressure <- gsub("qual_GREEN", "GREEN", clean_status2$FishingPressure)
plot_status_prop_pies(clean_status2, cap_month, cap_year)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_ICESpies", ext = "png", dir= "report"), width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_status_prop_pies(clean_status2, cap_month, cap_year, return_data = TRUE)
write.taf(dat, file =paste0(year_cap, "_", ecoreg, "SAG_ICESpies.csv"),dir ="report")

#~~~~~~~~~~~~~~~#
#E. GES pies
#~~~~~~~~~~~~~~~#

plot_GES_pies(clean_status2, catch_current2, cap_month, cap_year)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_GESpies", ext = "png",dir  = "report"),width = 178, height = 178, units = "mm",dpi = 300)

dat <- plot_GES_pies(clean_status2, catch_current2, cap_month, cap_year, return_data = TRUE)
write.taf(dat, file =paste0(year_cap, "_", ecoreg, "SAG_GESpies.csv"),dir ="report")

#~~~~~~~~~~~~~~~#
#F. ANNEX TABLE
#~~~~~~~~~~~~~~~#
#pending

dat <- format_annex_table(clean_status, year)

write.taf(dat, file =paste0(year_cap, "_", ecoreg, "SAG_annex_table.csv"), dir = "report", quote = TRUE)

format_annex_table_html(dat, cap_year, ecoreg_code)
# This annex table has to be edited by hand,
# For SBL and GES only one values is reported,
# the one in PA for SBL and the one in MSY for GES
