
library(icesTAF)
taf.library(icesFO)
library(sf)
library(ggplot2)
library(dplyr)


## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2022
cap_month <- "October"
ecoreg_code <- "NwS"
ecoreg <- "NwS"


mkdir("report")

# set values for automatic naming of files:
# year_cap = "2020"
# ecoreg = "NwS"

# ##########
#Load data
##########

ices_areas <-
  sf::st_read("areas.csv",
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ices_areas <- dplyr::select(ices_areas, -WKT)

ecoregion <-
  sf::st_read("ecoregion.csv",
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ecoregion <- dplyr::select(ecoregion, -WKT)

###############
##Ecoregion map
###############

plot_ecoregion_map(ecoregion, ices_areas)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"Figure1", ext = "png", dir = "report"), width = 170, height = 200, units = "mm", dpi = 300)


