#!/bin/bash -i
#Pipe.04.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
input_folder=$main_folder/eagle_out_filtered
output_folder=$main_folder/SNV_call

mkdir -p $output_folder

module load samtools/1.10
module load gatk/4.1.7.0


cd $output_folder



while read MID_no; do

	#defining labels for input/output files
	#MID_no="kamxxx"
	echo $MID_no
			
	input_ahal=$MID_no.ahal
	input_alyr=$MID_no.alyr

	echo $input_ahal
	echo $input_alyr

	#SNV Call for H-homeologs	
	gatk HaplotypeCaller\
	 -R $reference_folder/Ahal_v2_2_1.fa\
	 -I $input_folder/$MID_no.ahal.filtered.bam\
	 --emit-ref-confidence GVCF \
	 --bam-output $output_folder/$MID_no.ahal.hpcall.bam\
	 -O $output_folder/$MID_no.ahal.g.vcf.gz 

#SNV Call for L-homeologs	
	gatk HaplotypeCaller\
	 -R $reference_folder/Alyr_v2_2_1.fa\
	 -I $input_folder/$MID_no.alyr.filtered.bam\
	 --emit-ref-confidence GVCF \
	 --bam-output $output_folder/$MID_no.alyr.hpcall.bam\
	 -O $output_folder/$MID_no.alyr.g.vcf.gz 
	
	echo

done < $SCRIPT_DIR/MID_list.txt #list of kam_MID

cd $SCRIPT_DIR

module unload samtools/1.10
module unload gatk/4.1.7.0

