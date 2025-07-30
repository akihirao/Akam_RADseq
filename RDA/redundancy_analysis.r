# redundancy_analysis.r
# https://wec.wur.nl/r/spatial/raster-data.html

library(tidyverse)
library(psych)
library(adespatial)
library(vegan)

rm(list=ls(all=TRUE))

work_dir <- "/mnt/WD20v1/Akm/reanalysis/RDA"
setwd(work_dir)


# Import genetic data
allele_freqs = read.csv("allele_freqs.csv",
                        row.names = 1, check.names =FALSE)


# Import environmental data
env.raw = read_csv("../Sample_info/Akm_pop_info.csv") %>%
  dplyr::select(Pop_ID,
                c("Altitude")
  ) %>%
  filter(Pop_ID %in% row.names(allele_freqs))


# Import environmental data
if(FALSE){
env.raw = read_csv("../Sample_info/Akm_pop_info.csv") %>%
  dplyr::select(Pop_ID,
                c("Altitude",
                  "AnnualMeanAriTemp",
                  "AnnualMaxAirTemp",
                  "AnnualMinAirTemp",
                  "MaxSnowDepth",
                  "ActualSunshineDuration",
                  "SolarRadiation")
                ) %>%
  filter(Pop_ID %in% row.names(allele_freqs))
}
env.raw$Pop_ID <- factor(env.raw$Pop_ID,
                         levels=row.names(allele_freqs))  

env.df <- env.raw %>%
  arrange(Pop_ID) %>%
  dplyr::select(-Pop_ID) %>%
  as.data.frame()

row.names(env.df) <- row.names(allele_freqs)

# Import bioclim data
bioclim.raw = read.csv("bioclime_data.csv", 
                   row.names = 1)
bioclim.sorted = bioclim.raw[row.names(allele_freqs),]

env.df <- cbind(bioclim.sorted,env.df)
env.df <- bioclim.sorted
# Import 

set.seed(123)

pairs.panels(env.df, scale =TRUE)


library(usdm)
usdm::vif(bioclim.sorted)
vifstep_output <- usdm::vifstep(env.df)

remained_variable <- vifstep_output@results$Variables

env.data = subset(env.df, select= remained_variable)

pairs.panels(env.data, scale =TRUE)


env.for =forward.sel(Y = allele_freqs, X = env.data, alpha = 0.05)

env.sig = subset(env.data, select = env.for$variables)

#rda1 = rda(allele_freqs ~., data = env.sig, scale =TRUE)

rda1 = rda(allele_freqs ~., data = env.data, scale =TRUE)



# Model summaries
RsquareAdj(rda1) # adjusted Rsquared 
vif.cca(rda1) # variance inflation factor (<10 OK)
signif.full <- anova.cca(rda1, permutations = 1000) # full model
signif.full
signif.axis <- anova.cca(rda1, by="axis",permutations = 1000) # axis model
signif.axis
anova.cca(rda1, permutations = 1000, by="margin") # per variable 

# Variance explained by each canonical axis
summary(eigenvals(rda1, model = "constrained"))
screeplot(rda1)


# Create a dataframe to correctly colour regions
col_dframe = data.frame("site" = rownames(allele_freqs))

plot(rda1, type="n", scaling = 1)
title("Landscape redundancy analysis")
points(rda1, display="species", pch=21, scaling=1, cex=0.5, col="grey") # SNPs
#Site
points(rda1, display="sites", pch=21, scaling=1, cex=1.0, col="black") # sites
text(rda1, display="bp", scaling=1, col="darkblue", cex=1, lwd=2)


plot(rda1, type="n", scaling = 1)
title("Landscale redundancy analysis")
#Site
points(rda1, display="species", pch=21, scaling=1, cex=0.5, col="grey") # SNPs
text(rda1, display="bp", scaling=1, col="darkblue", cex=1, lwd=2)


snp.load = scores(rda1, choices = 1, display = "species")

hist(snp.load, main = "SNP loading on RDA1")



#=========================================
make_rda_outliers <- function(snp_load, z=2.5){
  
  #Identify SNPs in the tails of the distribution
  # Function from https://popgen.nescent.org/2018-03-27_RDA_GEA.html
  outliers = function(x,z){
    lims = mean(x) + c(-1, 1) * z * sd(x) # find loadings +/-z sd from mean loading     
    x[x < lims[1] | x > lims[2]]          # locus names in these tails
  }
  
  cand_name_RDAscore <- c()
  num_axis <- ncol(snp_load)
  for(i in 1:num_axis){
    cand_target <- outliers(x = snp.load[,i], z = z)
    cand_name_RDAscore <- c(cand_name_RDAscore,cand_target)
  }
  cand_name_common <- unique(names(cand_name_RDAscore))
  
  snp.load.df = snp.load  %>% as.data.frame
  snp.load.df$SNP_ID = rownames(snp.load.df)
  RDA_outliers_info <- snp.load.df %>% dplyr::filter(SNP_ID %in% cand_name_common)
  
  return(RDA_outliers_info)
  
}

RDA_outliers_info <- make_rda_outliers(snp_load=snp.load,
                                       z=2)



#========================================










#Identify SNPs in the tails of the distribution
# Function from https://popgen.nescent.org/2018-03-27_RDA_GEA.html
outliers = function(x,z){
  lims = mean(x) + c(-1, 1) * z * sd(x) # find loadings +/-z sd from mean loading     
  x[x < lims[1] | x > lims[2]]          # locus names in these tails
}

# x = loadings vector, z = number of standard deviations to use
candidates = outliers(x = snp.load, z = 2.5)

# Convert matric to dataframe
snp.load.df = snp.load %>% as.data.frame
snp.load.df$SNP_ID = rownames(snp.load.df)
str(snp.load.df)


# Extract locus ID
snp.load.df %>% dplyr::filter(RDA1 %in% candidates)


