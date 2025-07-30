# prepare_genetic_data.r
# https://wec.wur.nl/r/spatial/raster-data.html

library(adegenet)
library(vcfR)
library(poppr)
library(tidyverse)

work_dir <- "/home/akihirao/work/Chiopi/Chiopi_GRASDi/RDA"
setwd(work_dir)

rm(list=ls(all=TRUE))


# import individual lab
input_vcf_head="Chiopi_GRASDi_ref1_R1R3.snp.maf005"
vcf_path="/home/akihirao/work/Chiopi/Chiopi_GRASDi/vcf_out/all_sites"
#Extract sample IDs for admixture analysis
Cop_vcf <- read.vcfR(paste0(vcf_path,"/",input_vcf_head,".vcf.gz"))
Cop_gl <- vcfR2genlight(Cop_vcf)
sample_id <- Cop_gl@ind.names
ploidy(Cop_gl) <- 2

sample_id_tidy <- tibble(sample_ID=sample_id)


sample_info <- read_csv("/home/akihirao/work/Chiopi/Chiopi_GRASDi/Sample_info/Zuwai_GRASDi_sample_list.csv") %>%
  rename(sample_ID="Dry_ID")
sample_info$Stock <- factor(sample_info$Stock, levels=c("JS_A","JS_B","TH","DS","DT","OH"))

sample_info <- left_join(sample_id_tidy, sample_info,
                         join_by(sample_ID)) %>%
  mutate(subpop = Site)

sample_info$subpop <- str_replace_all(sample_info$subpop, pattern="JP1", replacement= "JP")
sample_info$subpop <- str_replace_all(sample_info$subpop, pattern="JP2", replacement= "JP")
sample_info$subpop <- str_replace_all(sample_info$subpop, pattern="JR1", replacement= "JR")
sample_info$subpop <- str_replace_all(sample_info$subpop, pattern="JR2", replacement= "JR")
sample_info$subpop <- str_replace_all(sample_info$subpop, pattern="JR3", replacement= "JR")
sample_info$subpop <- str_replace_all(sample_info$subpop, pattern="JR4", replacement= "JR")

pop(Cop_gl) <- sample_info$subpop

sample_site_summary <- sample_info %>% 
  group_by(subpop,Stock) %>% 
  summarise(n_sample = length(subpop),
            lon=mean(Longitude),
            lat=mean(Latitude)
  )

sample_site_summary_mt10 <- sample_site_summary %>%
  filter(n_sample >= 10)
subpop_mt10 <- sample_site_summary_mt10$subpop

Cop_gl_mt10 <- dartR::gl.keep.pop(Cop_gl,
                        pop.list = subpop_mt10,
                        recalc = TRUE,
                        mono.rm=TRUE)

Cop_gi_mt10 <- dartR::gl2gi(Cop_gl_mt10)

# Calculation allele frequencies
allele_freqs = data.frame(rraf(Cop_gi_mt10, by_pop = TRUE, correction =FALSE, check.names =FALSE))
allele_freqs = allele_freqs[, seq(1, dim(allele_freqs)[2],2)]

allele_freqs_non_mono = allele_freqs[, colSums(is.na(allele_freqs)) == 0]

write.csv(allele_freqs_non_mono, file="allele_freqs.csv",
          row.names=TRUE)
