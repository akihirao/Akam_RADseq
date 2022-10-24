#vcf2tess.Akm.R
#

library(tess3r)
library(maps)
library(tidyverse)

setwd("/home/akihirao/work/Akm/tess3_work")


#Akm_vcf <- vcfR::read.vcfR("/home/akihirao/work/Akm/Akm_RADseq/PCA/Akm.snp.maf001.LDpruned.vcf.gz")
#Ahal_vcf <- vcfR::read.vcfR("Akm.ahal.snp.maf001.LDpruned.vcf.gz")
#Alyr_vcf <- vcfR::read.vcfR("Akm.alyr.snp.maf001.LDpruned.vcf.gz")


#Read the ID data into R
ID_Pop <- read_table("/home/akihirao/work/Akm/Akm_RADseq/PCA/ID_Pop.txt")
ID_Pop_sorted_latitude <- ID_Pop %>% arrange(desc(Latitude),ID)
ID_Pop$Population <- factor(ID_Pop$Population, levels=unique(ID_Pop_sorted_latitude$Population))

no_ID <- length(ID_Pop$ID)
tess_Lat <- numeric(no_ID*2)
tess_Long <- numeric(no_ID*2)


for(i in 1:no_ID){
  first_input <- i*2-1
  second_input <- i*2
  tess_Lat[first_input] <- ID_Pop$Latitude[i]
  tess_Lat[second_input] <- ID_Pop$Latitude[i]
  tess_Long[first_input] <- ID_Pop$Longitude[i]
  tess_Long[second_input] <- ID_Pop$Longitude[i]
}

coord <- data.frame(tess_Long,tess_Lat)
Akm_str_raw <- read.table("Akm.snp.maf001.LDpruned.str",header=FALSE)
Akm_str <- Akm_str_raw[,-1]
Akm_str_coord <- cbind(coord,Akm_str)
Akm_tess3 <- tess2tess3(Akm_str_coord,TESS = TRUE, FORMAT = 2, extra.row= 0, extra.column = 0)

genotype = Akm_tess3$X
coordinates = Akm_tess3$coord


plot(coordinates, pch = 19, cex = .5, 
     xlab = "Longitude (°E)", ylab = "Latitude (°N)")
map(add = T, interior = F)


#Estimating ancestry coefficients
tess3.obj <- tess3(X = genotype, coord = coordinates, K = 1:10, 
                   method = "projected.ls", ploidy = 2, openMP.core.num = 8) 


plot(tess3.obj, pch = 19, col = "blue",
     xlab = "Number of ancestral populations",
     ylab = "Cross-validation score")


# retrieve tess3 Q matrix for K = 5 clusters 
q.matrix <- qmatrix(tess3.obj, K = 3)
# STRUCTURE-like barplot for the Q-matrix 
bp <- barplot(q.matrix, border = NA, space = 0, 
        xlab = "Individuals", ylab = "Ancestry proportions", 
        main = "Ancestry matrix")

## Use CreatePalette() to define color palettes.
axis(1, at = 1:nrow(q.matrix), labels = bp$order, las = 3, cex.axis = .4) 


plot(q.matrix, coordinates, method = "map.max", interpol = FieldsKrigModel(10),  
     main = "Ancestry coefficients",
     xlab = "Longitude", ylab = "Latitude", 
     resolution = c(300,300), cex = .4, 
     )
