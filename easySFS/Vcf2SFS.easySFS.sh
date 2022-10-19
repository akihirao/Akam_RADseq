#!/bin/bash
#Vcf2SFS.easySFS.sh 
#by Akira HIRAO

#Requirement
##easySFS: https://github.com/isaacovercast/easySFS
## Pop_ID.txt: the population assignment file

CURRENT_DIR=$(cd $(dirname $0) && pwd)

main_folder=/home/$USER/work/Akm
easySFS_folder=$main_folder/easySFS_out

mkdir -p $easySFS_folder
cd $easySFS_folder

## Vcf samples including singleton
# Arabidopsis kamchatica genome
~/bin/easySFS/easySFS.py -i $vcf_folder/Akm.ahal.snp.singleton.LDpruned.vcf -p Pop_ID.txt --preview -a  
~/bin/easySFS/easySFS.py -i $vcf_folder/Akm.ahal.snp.singleton.LDpruned.vcf -p Pop_ID.txt -o Ahal.singleton.LDpruned --proj 74,110,60 -a

# Arabidopsis halleri subgenome
~/bin/easySFS/easySFS.py -i $vcf_folder/Akm.alyr.snp.singleton.LDpruned.vcf -p Pop_ID.txt --preview -a  
~/bin/easySFS/easySFS.py -i $vcf_folder/Akm.alyr.snp.singleton.LDpruned.vcf -p Pop_ID.txt -o Alyr.singleton.LDpruned --proj 74,110,60 -a 

# Arabidopsis lyrata subgenome
~/bin/easySFS/easySFS.py -i $vcf_folder/Akm.snp.singleton.LDpruned.vcf -p Pop_ID.txt --preview -a  
~/bin/easySFS/easySFS.py -i $vcf_folder/Akm.snp.singleton.LDpruned.vcf -p Pop_ID.txt -o Akm.singleton.LDpruned --proj 74,110,60 -a  

cd $CURRENT_DIR
