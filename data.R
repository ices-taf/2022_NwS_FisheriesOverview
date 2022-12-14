# Initial formatting of the data

library(icesTAF)
library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")
# effort$sub.region <- tolower(effort$sub.region)
# unique(effort$sub.region)


# 1: ICES official catch statistics

hist <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_2006_2019_catches.csv")
prelim <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <-
  format_catches(2022, "Norwegian Sea",
    hist, official, NULL, species_list, sid)

write.taf(catch_dat, dir = "data", quote = TRUE)


# 2: SAG
# sag_sum <- read.taf("bootstrap/data/SAG_data/SAG_complete_BrS.csv")
# # sag_refpts <- read.taf("bootstrap/data/SAG_data/SAG_refpts.csv")
# sag_status <- read.taf("bootstrap/data/SAG_data/SAG_status_BrS.csv")


# 2022 update: this still applies:
sag_complete$FMSY[which(sag_complete$FishStock == "pok.27.1-2")] <- 0.32
sag_complete$MSYBtrigger[which(sag_complete$FishStock == "pok.27.1-2")] <- 220000

sag_complete$FMSY[which(sag_complete$FishStock == "cod.27.1-2.coastN")] <- 0.176
sag_complete$MSYBtrigger[which(sag_complete$FishStock == "cod.27.1-2.coastN")] <- 67743

sag_complete$MSYBtrigger[which(sag_complete$FishStock == "reg.27.1-2")] <- 68600 #PA
# sag_complete$MSYBtrigger[which(sag_complete$FishStock == "cod.27.1-2")] <- 200000 #PA

#DGS has a custom ref point for F but we should not plot the SSB one instead
sag_complete$FMSY[which(sag_complete$FishStock == "dgs.27.nea")] <- 0.0429543
sag_complete$MSYBtrigger[which(sag_complete$FishStock == "dgs.27.nea")] <- NA

clean_sag <- format_sag(sag_complete, sid)
clean_status <- format_sag_status(status, 2022, "Norwegian Sea")

Norwegian_stockList <- c("aru.27.123a4",
                         "bli.27.nea",
                         "bsf.27.nea",
                         "bsk.27.nea",
                         "cap.27.2a514",
                          "cod.27.1-2",
                         "cod.27.1-2.coastN",
                         "dgs.27.nea",
                         "gfb.27.nea",
                          "ghl.27.1-2",
                          "had.27.1-2",
                         "her.27.1-24a514a",
                         "hom.27.2a4a5b6a7a-ce-k8",
                         "lin.27.1-2",
                         "mac.27.nea",
                         "pok.27.1-2",
                         "por.27.nea",
                          "reb.27.1-2",
                         "reg.27.1-2",
                         "rjr.27.23a4",
                         "rng.27.1245a8914ab",
                         "usk.27.1-2",
                         "whb.27.1-91214")

clean_sag<-clean_sag %>% filter(StockKeyLabel %in% Norwegian_stockList)
clean_status<-clean_status %>% filter(StockKeyLabel %in% Norwegian_stockList)

#new pies plots without the 5 stocks
clean_status_rev<-clean_status %>% filter(StockKeyLabel %in% Norwegian_stockList)

write.taf(clean_sag, dir = "data", quote = TRUE)
write.taf(clean_status, dir = "data", quote = TRUE)
