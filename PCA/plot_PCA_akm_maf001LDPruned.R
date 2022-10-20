#plot_PCA_akm_maf001LDPruned.R

library(vcfR)
library(poppr)
library(ape)
library(adegenet)
library(RColorBrewer)
library(tidyverse)
library(gridExtra)

Akm_vcf <- vcfR::read.vcfR("Akm.snp.maf001.LDpruned.vcf.gz")
Ahal_vcf <- vcfR::read.vcfR("Akm.ahal.snp.maf001.LDpruned.vcf.gz")
Alyr_vcf <- vcfR::read.vcfR("Akm.alyr.snp.maf001.LDpruned.vcf.gz")


#Read the ID data into R
Pop_ID <- read.table("ID_Pop.txt", header = FALSE)
colnames(Pop_ID) <- c("ID","Pop")

#Convert to genind
Akm_genind <- vcfR2genind(Akm_vcf)
pop(Akm_genind) <- Pop_ID$Pop
no_pop <- length(unique(pop(Akm_genind)))
Akm_id <- indNames(Akm_genind)

Ahal_genind <- vcfR2genind(Ahal_vcf)
pop(Ahal_genind) <- Pop_ID$Pop
Ahal_id <- indNames(Ahal_genind)

Alyr_genind <- vcfR2genind(Alyr_vcf)
pop(Alyr_genind) <- Pop_ID$Pop
Alyr_id <- indNames(Alyr_genind)


#Convert to genlight
Akm_gl <- vcfR2genlight(Akm_vcf)
ploidy(Akm_gl) <- 2
pop(Akm_gl) <- Pop_ID$Pop

Ahal_gl <- vcfR2genlight(Ahal_vcf)
ploidy(Ahal_gl) <- 2
pop(Ahal_gl) <- Pop_ID$Pop

Alyr_gl <- vcfR2genlight(Alyr_vcf)
ploidy(Alyr_gl) <- 2
pop(Alyr_gl) <- Pop_ID$Pop


#glPlot(Akm_gl)


# Peforming PCA
Akm_gl_pca <- glPca(Akm_gl, nf = 20, n.cores= 4)
Akm_PC1_contribute <- round(100*Akm_gl_pca$eig[1]/sum(Akm_gl_pca$eig),digits=1)
Akm_PC2_contribute <- round(100*Akm_gl_pca$eig[2]/sum(Akm_gl_pca$eig),digits=1)
Akm_PC1_contribute_lab <- str_c("PC1"," (",Akm_PC1_contribute,"%)")
Akm_PC2_contribute_lab <- str_c("PC2"," (",Akm_PC2_contribute,"%)")

Ahal_gl_pca <- glPca(Ahal_gl, nf = 20, n.cores= 4)
Ahal_PC1_contribute <- round(100*Ahal_gl_pca$eig[1]/sum(Ahal_gl_pca$eig),digits=1)
Ahal_PC2_contribute <- round(100*Ahal_gl_pca$eig[2]/sum(Ahal_gl_pca$eig),digits=1)
Ahal_PC1_contribute_lab <- str_c("PC1"," (",Ahal_PC1_contribute,"%)")
Ahal_PC2_contribute_lab <- str_c("PC2"," (",Ahal_PC2_contribute,"%)")

Alyr_gl_pca <- glPca(Alyr_gl, nf = 20, n.cores= 4)
Alyr_PC1_contribute <- round(100*Alyr_gl_pca$eig[1]/sum(Alyr_gl_pca$eig),digits=1)
Alyr_PC2_contribute <- round(100*Alyr_gl_pca$eig[2]/sum(Alyr_gl_pca$eig),digits=1)
Alyr_PC1_contribute_lab <- str_c("PC1"," (",Alyr_PC1_contribute,"%)")
Alyr_PC2_contribute_lab <- str_c("PC2"," (",Alyr_PC2_contribute,"%)")

Akm_gl_pca_scores <- as.data.frame(Akm_gl_pca$scores)
Akm_gl_pca_scores$pop <- pop(Akm_gl)

Ahal_gl_pca_scores <- as.data.frame(Ahal_gl_pca$scores)
Ahal_gl_pca_scores$pop <- pop(Ahal_gl)

Alyr_gl_pca_scores <- as.data.frame(Alyr_gl_pca$scores)
Alyr_gl_pca_scores$pop <- pop(Alyr_gl)


Akm_gl_PCA_plot <- ggplot(Akm_gl_pca_scores, aes(x=PC1, y=PC2, colour=pop)) + 
  ggtitle("Both homeologs combined") + 
  xlab(Akm_PC1_contribute_lab) + ylab(Akm_PC2_contribute_lab) +
  geom_point(alpha=0.5, size=0.5) + 
  stat_ellipse(level = 0.95, size = 0.5) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  theme_bw()

Akm_gl_PCA_plot <- ggplot(Akm_gl_pca_scores, aes(x=PC1, y=PC2, colour=pop)) + 
  ggtitle("Arabidopsis kamchatica as allopolyploid") + 
  xlab(Akm_PC1_contribute_lab) + ylab(Akm_PC2_contribute_lab) +
  geom_point(alpha=0.5, size=0.8) + 
  stat_ellipse(level = 0.95, size = 0.3) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  theme_bw()

Ahal_gl_PCA_plot <- ggplot(Ahal_gl_pca_scores, aes(x=PC1, y=PC2, colour=pop)) + 
  ggtitle("Arabidopsis halleri homeologs") + 
  xlab(Ahal_PC1_contribute_lab) + ylab(Ahal_PC2_contribute_lab) +
  geom_point(alpha=0.5, size=0.8) + 
  stat_ellipse(level = 0.95, size = 0.3) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  theme_bw()

Alyr_gl_PCA_plot <- ggplot(Alyr_gl_pca_scores, aes(x=PC1, y=PC2, colour=pop)) + 
  ggtitle("Arabidopsis lyrata homeologs") + 
  xlab(Alyr_PC1_contribute_lab) + ylab(Alyr_PC2_contribute_lab) +
  geom_point(alpha=0.5, size=0.8) + 
  stat_ellipse(level = 0.95, size = 0.3) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  theme_bw()


layout_1 <- rbind(c(1,2),
                  c(3,3),
                  c(3,3))

Akm_gl_PCA_plot_all <- gridExtra::grid.arrange(Ahal_gl_PCA_plot,Alyr_gl_PCA_plot,Akm_gl_PCA_plot,layout_matrix=layout_1)
plot(Akm_gl_PCA_plot_all)
