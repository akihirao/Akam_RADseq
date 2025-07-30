# prepare_env_data.r
# https://wec.wur.nl/r/spatial/raster-data.html

library(terra)
library(raster)
library(geodata)

work_dir <- "/mnt/WD20v1/Akm/reanalysis/RDA"
setwd(work_dir)

rm(list=ls(all=TRUE))
# Import coordinates of sites
coords = read_csv("coordinates.csv")
points_raw = coords %>%
  dplyr::select(Lon,Lat) %>%
  rename(lon="Lon",
         lat="Lat")

points = vect(points_raw, geom = c("lon","lat"), crs = "EPSG:4326")

# Create SpatialPoints object using coordinate
#points = SpatialPoints(subset(coords, select = c("Lon","Lat")),
#                       proj4string = CRS("+proj=longlat +datum=WGS84"))

#bio <- worldclim_country("Japan", var = "bio", res = 0.5, version = "2.1",
#                         path = "~/data/WorldClim/Jpn")


bio <- rast("~/data/WorldClim/Jpn/climate/wc2.1_country/JPN_wc2.1_30s_bio.tif")

bio_JALPS <- crop(bio, ext(136.5,139.5,34.5,37.5))

bio_JALPS_1_12 <- subset(bio_JALPS, paste0("wc2.1_30s_bio_",seq(1:12)))
bio_JALPS_13_19 <- subset(bio_JALPS, paste0("wc2.1_30s_bio_",seq(13:19)))

pdf("bio_JALPS_1_12.pdf")
plot(bio_JALPS_1_12)
dev.off()

pdf("bio_JALPS_13_19.pdf")
plot(bio_JALPS_13_19)
dev.off()

env_values <- extract(bio, points) %>% 
  mutate(site=coords$Site) %>%
  dplyr::select(-ID)

names(env_values) <- c(paste0("bio_",seq(1:19)),"site")
env_values <- env_values %>%
  dplyr::select(site, paste0("bio_", seq(1:19)))

write_csv(env_values,
          "bioclime_data.csv")
