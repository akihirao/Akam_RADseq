#!/bin/bash
#Pipe.04.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20v1/Akm/reanalysis/Reference
main_folder=/mnt/WD20v1/Akm/reanalysis
script_folder=$main_folder/Scripts
input_folder=$main_folder/eagle_out_filtered
output_folder=$main_folder/SNV_call

mkdir -p $output_folder

module load samtools/1.10
module load gatk4/4.3.0.0


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
	 --native-pair-hmm-threads $no_threads\
	 -O $output_folder/$MID_no.ahal.g.vcf.gz 

#SNV Call for L-homeologs	
	gatk HaplotypeCaller\
	 -R $reference_folder/Alyr_v2_2_1.fa\
	 -I $input_folder/$MID_no.alyr.filtered.bam\
	 --emit-ref-confidence GVCF \
	 --bam-output $output_folder/$MID_no.alyr.hpcall.bam\
	 --native-pair-hmm-threads $no_threads\
	 -O $output_folder/$MID_no.alyr.g.vcf.gz 
	
	echo

done < $script_folder/MID_list.txt #list of kam_MID

cd $CURRENT_DIR

module unload samtools/1.10
module unload gatk4/4.3.0.0

