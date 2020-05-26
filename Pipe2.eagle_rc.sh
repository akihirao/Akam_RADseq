#!/bin/bash
#Pipe2.eagle_rc.sh

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4


module load samtools/1.10

#foloder stored for BAM files
source_data_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/bwa_out
reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle

EAGLE_OUT=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/eagle_out
EAGLE_OUT_RENAME=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/eagle_out_rename

mkdir -p $EAGLE_OUT
mkdir -p $EAGLE_OUT_RENAME

cd $EAGLE_OUT


while read MID_no; do

	#defining labels for input/output files
	#MID_no="kamxxx"
	echo $MID_no
	ahal_lab="_ahal"
	alyr_lab="_alyr"
	out_lab="_out"
	out1_lab="_out1"
	out2_lab="_out2"
	orig_lab="_orig"
	ahal_eagle_lab="_out1.ref"
	alyr_eagle_lab="_out2.ref"
	
	input_ahal=$MID_no$ahal_lab
	input_alyr=$MID_no$alyr_lab
	input_eagle_ahal=$MID_no$ahal_eagle_lab
	input_eagle_alyr=$MID_no$alyr_eagle_lab

	output_ahal=$MID_no$ahal_lab$orig_lab
	output_alyr=$MID_no$alyr_lab$orig_lab

	MID_out_lab=$MID_no$out_lab
	MID_out1_lab=$MID_no$out1_lab
	MID_out2_lab=$MID_no$out2_lab

	/usr/local/eagle/eagle-rc --ngi -o $MID_out_lab --ref1=$reference_folder/Ahal_v2_2_1.fa --ref2=$reference_folder/Alyr_v2_2_1.fa --bam1=$source_data_folder/$input_ahal.bam --bam2=$source_data_folder/$input_alyr.bam --paired --isc > $MID_no.classified_reads.1vs2.list
	
	cp $input_eagle_ahal.bam $EAGLE_OUT_RENAME/$MID_no.ahal.bam
	samtools index -@ $CPU $EAGLE_OUT_RENAME/$MID_no.ahal.bam
	cp $input_eagle_alyr.bam $EAGLE_OUT_RENAME/$MID_no.alyr.bam
	samtools index -@ $CPU $EAGLE_OUT_RENAME/$MID_no.alyr.bam

	echo

done < $SCRIPT_DIR/MID_list.txt #list of kam_MID

cd $SCRIPT_DIR

module unload samtools/1.10
