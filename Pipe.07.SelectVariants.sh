#!/bin/bash -i
#Pipe.07.SelectVariants.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
work_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/vcf_out


module load samtools/1.10
module load gatk/4.1.7.0

cd $work_folder


#Extracting snp for H homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O Akm.ahal.raw.snp.vcf.gz

#Extracting indel for H homeologs
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.raw.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O Akm.ahal.raw.indel.vcf.gz



#Extracting snp for L homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O Akm.alyr.raw.snp.vcf.gz

#Extracting indel for L homeologs
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.raw.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O Akm.alyr.raw.indel.vcf.gz


cd $SCRIPT_DIR

module unload samtools/1.10
module unload gatk/4.1.7.0

