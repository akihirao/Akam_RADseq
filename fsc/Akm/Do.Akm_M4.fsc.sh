#!/bin/bash
#Do.Akm_M4.fsc.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

#Set no threads
no_threads=2

main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
fsc_work_folder=$main_folder/fsc_work/Akm


PREFIX="Akm"
MODEL="M4"
LAB="_"
PREFIX_MODEL=$PREFIX$LAB$MODEL

mkdir -p $fsc_work_folder/$MODEL


no_sim=100000
no_cycle=50

for i in {1..100}
do
	cd $fsc_work_folder/$MODEL
	mkdir run$i
	cd run$i
	cp $fsc_work_folder"/"${PREFIX}_jointMAFpop1_0.obs $fsc_work_folder"/"$MODEL"/"run$i"/"${PREFIX_MODEL}_jointMAFpop1_0.obs
	cp $fsc_work_folder"/"${PREFIX}_jointMAFpop2_0.obs $fsc_work_folder"/"$MODEL"/"run$i"/"${PREFIX_MODEL}_jointMAFpop2_0.obs
	cp $fsc_work_folder"/"${PREFIX}_jointMAFpop2_1.obs $fsc_work_folder"/"$MODEL"/"run$i"/"${PREFIX_MODEL}_jointMAFpop2_1.obs
	cp $fsc_work_folder"/"${PREFIX_MODEL}.tpl $fsc_work_folder"/"$MODEL"/"run$i"/"
	cp $fsc_work_folder"/"${PREFIX_MODEL}.est $fsc_work_folder"/"$MODEL"/"run$i"/"

	#Perform fastsimcoal2
	fsc -t ${PREFIX_MODEL}.tpl -e ${PREFIX_MODEL}.est -n $no_sim -M -m --removeZeroSFS -L $no_cycle -q -c $no_threads

done


cd $CURRENT_DIR