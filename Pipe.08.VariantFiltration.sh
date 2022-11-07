#!/bin/bash
#Pipe.08.VariantFiltration.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20/Akm/reanalysis/Reference
main_folder=/mnt/WD20/Akm/reanalysis
script_folder=$main_folder/Scripts
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering

cluster_size=200

module load samtools/1.10
module load gatk4/4.3.0.0
module load vcftools/0.1.16
module load bcftools/1.16

cd $vcf_folder
mkdir -p $plink_folder


###############################################################
###############################################################
#Filtering out excess Heterozygosity
#
#defining ExcessHet parameter
#"ExcessHet > 13.0" means excess of heterozygosity with p value 0.05 
ExcessHet_P=0.05
ExcessHet_Q=`echo "scale=5; -10 * l($ExcessHet_P) /l(10)" |bc -l | xargs printf %.1f`
ExcessHet_param="ExcessHet > ${ExcessHet_Q}"
echo $ExcessHet_param


#Making select sited that having ExcessHet: H-homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.vcf.gz\
 -select "${ExcessHet_param}"\
 -O Akm.ahal.ExcessHet.vcf

#Making bed file that marked ExcessHet block: H-homeologs
perl $script_folder/Vcf2BED_chr_start_end.pl < Akm.ahal.ExcessHet.vcf | bedtools cluster -d $cluster_size > Akm.ahal.ExcessHet.cluster.bed
perl $script_folder/ClusterBedBlock.pl < Akm.ahal.ExcessHet.cluster.bed > Akm.ahal.ExcessHet.block.bed


#Making select sited that having ExcessHet: L-homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.vcf.gz\
 -select "${ExcessHet_param}"\
 -O Akm.alyr.ExcessHet.vcf

#Making bed file that marked ExcessHet block: L-homeologs
perl $script_folder/Vcf2BED_chr_start_end.pl < Akm.alyr.ExcessHet.vcf | bedtools cluster -d $cluster_size > Akm.alyr.ExcessHet.cluster.bed
perl $script_folder/ClusterBedBlock.pl < Akm.alyr.ExcessHet.cluster.bed > Akm.alyr.ExcessHet.block.bed

#=====================================================================
#filtering out ExcessHetblock: SNPs on H-homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.snp.vcf.gz\
 --exclude-intervals Akm.ahal.ExcessHet.block.bed\
 -O Akm.ahal.raw.snp.no_ExcessHetBlock.vcf.gz

#filtering out ExcessHetblock: INDELs on H-homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.indel.vcf.gz\
 --exclude-intervals Akm.ahal.ExcessHet.block.bed\
 -O Akm.ahal.raw.indel.no_ExcessHetBlock.vcf.gz

#filtering out ExcessHetblock: Non-variants on H-homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.non_variant.vcf.gz\
 --exclude-intervals Akm.ahal.ExcessHet.block.bed\
 -O Akm.ahal.raw.non_variant.no_ExcessHetBlock.vcf.gz


#filtering out ExcessHetblock: SNPs on L-homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.snp.vcf.gz\
 --exclude-intervals Akm.alyr.ExcessHet.block.bed\
 -O Akm.alyr.raw.snp.no_ExcessHetBlock.vcf.gz

#filtering out ExcessHetblock: INDELs on L-homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.indel.vcf.gz\
 --exclude-intervals Akm.alyr.ExcessHet.block.bed\
 -O Akm.alyr.raw.indel.no_ExcessHetBlock.vcf.gz

#filtering out ExcessHetblock: Non-variants on L-homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.non_variant.vcf.gz\
 --exclude-intervals Akm.alyr.ExcessHet.block.bed\
 -O Akm.alyr.raw.non_variant.no_ExcessHetBlock.vcf.gz
#=====================================================================
######################################################################
######################################################################

#Site-based filtering of SNPs on H-homeologs
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.snp.no_ExcessHetBlock.vcf.gz \
 --filter-expression "MQ < 30.0" --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O Akm.ahal.snp.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of SNPs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.snp.filter.vcf.gz\
 --exclude-filtered\
 -O Akm.ahal.snp.filterPASSED.vcf.gz

#Site-based filtering of INDELs on H-homeologs
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.indel.no_ExcessHetBlock.vcf.gz \
 --filter-expression "MQ < 30.0" --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O Akm.ahal.indel.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of INDELs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.indel.filter.vcf.gz\
 --exclude-filtered\
 -O Akm.ahal.indel.filterPASSED.vcf.gz


#Site-based filtering of SNPs on L-homeologs
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.snp.no_ExcessHetBlock.vcf.gz \
 --filter-expression "MQ < 30.0" --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O Akm.alyr.snp.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of SNPs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.snp.filter.vcf.gz\
 --exclude-filtered\
 -O Akm.alyr.snp.filterPASSED.vcf.gz

#Site-based filtering of INDELs on L-homeologs
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.indel.no_ExcessHetBlock.vcf.gz \
  --filter-expression "MQ < 30.0" --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O Akm.alyr.indel.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of INDELs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.indel.filter.vcf.gz\
 --exclude-filtered\
 -O Akm.alyr.indel.filterPASSED.vcf.gz
#=====================================================================


#=====================================================================
#=====================================================================
#Sample-based filtering
#VariantFiltration for SNPs on H-homeologs
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.snp.filterPASSED.vcf.gz\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.ahal.snp.DPfilterPASSED.vcf

#VariantFiltration for INDELs on H-homeologs
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.indel.filterPASSED.vcf.gz\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.ahal.indel.DPfilterPASSED.vcf

#VariantFiltration for Non-variants on H-homeologs
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.non_variant.no_ExcessHetBlock.vcf.gz\
 -G-filter "DP < 5 || RGQ < 30.0"\
 -G-filter-name "DP5_RGQ30"\
 -O Akm.ahal.non_variant.DPfilterPASSED.vcf

#-----------------------------------------------------
#VariantFiltration for SNPs on L-homeologs
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.snp.filterPASSED.vcf.gz\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.alyr.snp.DPfilterPASSED.vcf

#VariantFiltration for INDELs on L-homeologs
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.indel.filterPASSED.vcf.gz\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.alyr.indel.DPfilterPASSED.vcf

#VariantFiltration for Non-variants on L-homeologs
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.non_variant.no_ExcessHetBlock.vcf.gz\
 -G-filter "DP < 5 || RGQ < 30.0"\
 -G-filter-name "DP5_RGQ30"\
 -O Akm.alyr.non_variant.DPfilterPASSED.vcf
#=======================================-

#Set filtered sites to no call: SNPs on H-homeologs
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.snp.DPfilterPASSED.vcf\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.ahal.snp.DPfilterNoCall.vcf.gz

#Set filtered sites to no call: INDELs on H-homeologs
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.indel.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.ahal.indel.DPfilterNoCall.vcf.gz

#Set filtered sites to no call: Non-variants on H-homeologs
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.non_variant.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.ahal.non_variant.DPfilterNoCall.vcf.gz

#---------------------------------------------------------------------
#Set filtered sites to no call: SNPs on L-homeologs
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.snp.DPfilterPASSED.vcf\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.alyr.snp.DPfilterNoCall.vcf.gz

#Set filtered sites to no call: INDELs on L-homeologs
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.indel.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.alyr.indel.DPfilterNoCall.vcf.gz

#Set filtered sites to no call: Non-variants on L-homeologs
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.non_variant.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.alyr.non_variant.DPfilterNoCall.vcf.gz

#=====================================================================

#Merging SNPs + Non-variants on H-homeologs
gatk MergeVcfs\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -I Akm.ahal.snp.DPfilterNoCall.vcf.gz\
 -I Akm.ahal.non_variant.DPfilterNoCall.vcf.gz\
 -O Akm.ahal.snp.non_variant.DPfilterNoCall.vcf.gz

#Merging SNPs + Non-variants on L-homeologs
gatk MergeVcfs\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -I Akm.alyr.snp.DPfilterNoCall.vcf.gz\
 -I Akm.alyr.non_variant.DPfilterNoCall.vcf.gz\
 -O Akm.alyr.snp.non_variant.DPfilterNoCall.vcf.gz


cd $CURRENT_DIR

module unload samtools/1.10
module unload gatk/4.3.0.0
module unload vcftools/0.1.16
module unload bcftools/1.16

