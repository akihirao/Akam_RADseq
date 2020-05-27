#!/bin/bash -i
#Pipe.03.BamFiltering.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle

input_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/eagle_out_rename
output_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/eagle_out_filtered

mkdir -p $output_folder

module load samtools/1.10

cd $output_folder



while read MID_no; do

	#defining labels for input/output files
	#MID_no="kamxxx"
	echo $MID_no
			
	input_ahal=$MID_no.ahal
	input_alyr=$MID_no.alyr

	echo $input_ahal
	echo $input_alyr

	#Filtering BAM forH-homeologs	
	samtools view -@ $CPU -b -F 256 -q 4 $input_folder/$MID_no.ahal.bam > $MID_no.ahal.filtered.bam
	samtools index -@ $CPU $MID_no.ahal.filtered.bam

	#Filtering BAM forL-homeologs	
	samtools view -@ $CPU -b -F 256 -q 4 $input_folder/$MID_no.alyr.bam > $MID_no.alyr.filtered.bam
	samtools index -@ $CPU $MID_no.alyr.filtered.bam
	
	echo

done < $SCRIPT_DIR/MID_list.txt #list of kam_MID

cd $SCRIPT_DIR

module unload samtools/1.10

