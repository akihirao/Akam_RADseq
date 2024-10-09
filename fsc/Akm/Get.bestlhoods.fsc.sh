#!/bin/bash
#Get.bestlhoods.fsc.sh
#how to use: >Get.bestlhoods.fcs.sh PREFIX MODEL no_run

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)
main_folder=$CURRENT_DIR


#PREFIX="Traja"
PREFIX=$1
LAB="_"
#MODEL="1PopG1"
MODEL=$2
PREFIX_MODEL=$PREFIX$LAB$MODEL
#no_run=40
no_run=$3

#prepare an output file
echo -n >| $main_folder"/"$PREFIX_MODEL.summary.bestlhoods

cd $main_folder"/"$MODEL

#get a resut of 1st run 
cd run1
cat $PREFIX_MODEL"/"$PREFIX_MODEL.bestlhoods >> $main_folder"/"$PREFIX_MODEL.summary.bestlhoods
cd ../


for((i =2; i <= $no_run; i++))
do
	cd run$i
	sed -n 2p $PREFIX_MODEL"/"$PREFIX_MODEL.bestlhoods >> $main_folder"/"$PREFIX_MODEL.summary.bestlhoods
cd ../
done

