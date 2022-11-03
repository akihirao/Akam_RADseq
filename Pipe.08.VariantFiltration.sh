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

module load samtools/1.10
module load gatk4/4.3.0.0
module load vcftools/0.1.16
module load bcftools/1.16

cd $vcf_folder
mkdir -p $plink_folder


#defining ExcessHet parameter
#"ExcessHet > 13.0" means excess of heterozygosity with p value 0.05 
ExcessHet_P=0.05
ExcessHet_Q=`echo "scale=5; -10 * l($ExcessHet_P) /l(10)" |bc -l | xargs printf %.1f`
ExcessHet_param="ExcessHet > ${ExcessHet_Q}"
echo $ExcessHet_param
#=====================================================================
#H homeologs
#VariantFiltration for SNP
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.snp.vcf.gz\
 --filter-expression "MQ < 30.0"\
 --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}"\
 --filter-name "ExHet"\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.ahal.snp.filter.vcf

grep -E '^#|PASS' Akm.ahal.snp.filter.vcf > Akm.ahal.snp.filterPASSED.vcf


#VariantFiltration for INDEL
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.indel.vcf.gz\
 -filter-expression "MQ < 30.0"\
 --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}"\
 --filter-name "ExHet"\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.ahal.indel.filter.vcf

grep -E '^#|PASS' Akm.ahal.indel.filter.vcf > Akm.ahal.indel.filterPASSED.vcf


#Set filtered sites to no call:SNP
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.snp.filterPASSED.vcf\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.ahal.snp.DPfilterNoCall.vcf
bgzip -c Akm.ahal.snp.DPfilterNoCall.vcf > Akm.ahal.snp.DPfilterNoCall.vcf.gz
tabix -f -p vcf Akm.ahal.snp.DPfilterNoCall.vcf.gz
bcftools index -f Akm.ahal.snp.DPfilterNoCall.vcf.gz



#Set filtered sites to no call:INDEL
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.indel.filterPASSED.vcf\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.ahal.indel.DPfilterNoCall.vcf
bgzip -c Akm.ahal.indel.DPfilterNoCall.vcf > Akm.ahal.indel.DPfilterNoCall.vcf.gz
tabix -f -p vcf Akm.ahal.indel.DPfilterNoCall.vcf.gz
bcftools index -f Akm.ahal.indel.DPfilterNoCall.vcf.gz

#=====================================================================





#=====================================================================
#L homeologs
#VariantFiltration for SNP
#ExcessHet > 13 means excess of heterozygosity with p value 0.05 
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.snp.vcf.gz\
 --filter-expression "MQ < 30.0"\
 --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}"\
 --filter-name "ExHet"\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.alyr.snp.filter.vcf

grep -E '^#|PASS' Akm.alyr.snp.filter.vcf > Akm.alyr.snp.filterPASSED.vcf

#VariantFiltration for INDEL
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.indel.vcf.gz\
 -filter-expression "MQ < 30.0"\
 --filter-name "MQ30"\
 --filter-expression "${ExcessHet_param}"\
 --filter-name "ExHet"\
 -G-filter "DP < 5 || GQ < 30.0"\
 -G-filter-name "DP5_GQ30"\
 -O Akm.alyr.indel.filter.vcf

grep -E '^#|PASS' Akm.alyr.indel.filter.vcf > Akm.alyr.indel.filterPASSED.vcf


#Set filtered sites to no call:SNP
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.snp.filterPASSED.vcf\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.alyr.snp.DPfilterNoCall.vcf
bgzip -c Akm.alyr.snp.DPfilterNoCall.vcf > Akm.alyr.snp.DPfilterNoCall.vcf.gz
tabix -f -p vcf Akm.alyr.snp.DPfilterNoCall.vcf.gz
bcftools index -f Akm.alyr.snp.DPfilterNoCall.vcf.gz


#Set filtered sites to no call:INDEL
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.indel.filterPASSED.vcf\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O Akm.alyr.indel.DPfilterNoCall.vcf
bgzip -c Akm.alyr.indel.DPfilterNoCall.vcf > Akm.alyr.indel.DPfilterNoCall.vcf.gz
tabix -f -p vcf Akm.alyr.indel.DPfilterNoCall.vcf.gz
bcftools index -f Akm.alyr.indel.DPfilterNoCall.vcf.gz

#=====================================================================


cd $CURRENT_DIR

module unload samtools/1.10
module unload gatk/4.3.0.0
module unload vcftools/0.1.16
module unload bcftools/1.16
