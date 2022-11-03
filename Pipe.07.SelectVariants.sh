#!/bin/bash
#Pipe.07.SelectVariants.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20/Akm/reanalysis/Reference
main_folder=/mnt/WD20/Akm/reanalysis
script_folder=$main_folder/Scripts
vcf_folder=$main_folder/vcf_out

module load samtools/1.10
module load gatk4/4.3.0.0

cd $vcf_folder

#---------------------------------
#Extracting snp for H homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O Akm.ahal.raw.snp.vcf.gz

#Extracting non-variants for H homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.include_non_variant.vcf.gz\
 -select-type NO_VARIATION\
 -O Akm.ahal.raw.non_variant.vcf.gz

#Extracting indel for H homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O Akm.ahal.raw.indel.vcf.gz
#---------------------------------
#---------------------------------
#Extracting snp for L homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O Akm.alyr.raw.snp.vcf.gz

#Extracting non-variants for L homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.include_non_variant.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O Akm.alyr.raw.non_variant.vcf.gz

#Extracting indel for L homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O Akm.alyr.raw.indel.vcf.gz
#---------------------------------

cd $CURRENT_DIR

module unload samtools/1.10
module unload gatk/4.3.0.0

