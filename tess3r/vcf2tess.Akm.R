#vcf2tess.Akm.R
#

library(vcfR)
library(dartR)
library(tidyverse)

setwd("/home/akihirao/work/Akm/tess3_work")

Akm_vcf <- vcfR::read.vcfR("/home/akihirao/work/Akm/Akm_RADseq/PCA/Akm.snp.maf001.LDpruned.vcf.gz")
#Ahal_vcf <- vcfR::read.vcfR("Akm.ahal.snp.maf001.LDpruned.vcf.gz")
#Alyr_vcf <- vcfR::read.vcfR("Akm.alyr.snp.maf001.LDpruned.vcf.gz")


#Read the ID data into R
ID_Pop <- read_table("/home/akihirao/work/Akm/Akm_RADseq/PCA/ID_Pop.txt")
ID_Pop_sorted_latitude <- ID_Pop %>% arrange(desc(Latitude),ID)
ID_Pop$Population <- factor(ID_Pop$Population, levels=unique(ID_Pop_sorted_latitude$Population))


#Convert to genlight
Akm_gl <- vcfR2genlight(Akm_vcf)
ploidy(Akm_gl) <- 2
pop(Akm_gl) <- ID_Pop$Population

dartR::gl2structure(Akm_gl,
                    exportMarkerNames = FALSE,
                    outfile="Akm.snp.maf001.LDpruned.str",
                    outpath="/home/akihirao/work/Akm/tess3_work",
                    verbose=5)
