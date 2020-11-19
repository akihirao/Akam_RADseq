#!/bin/bash -i
#Calc.pi.Akm.sh
#by HIRAO Akira


SCRIPT_DIR=$(cd $(dirname $0) && pwd)

#reference_folder=/media/walnut/cranberry/data/Akm_RAD/Reference/Ahal_Alyr_v2_2_1/eagle
#main_folder=/media/walnut/cranberry2/data/Akm_RAD_eagle_gatk
#cd $main_folder

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering
pi_folder=$main_folder/pi_work


module load samtools/1.10
module load gatk/4.1.7.0
module load vcftools/0.1.15

mkdir -p $pi_folder
cd $pi_folder

#vcftools --gzvcf Akm.ahal.nonvariable.NoExHet.ForPi.vcf.gz --site-pi --stdout > Akm.ahal.site.pi.out
#vcftools --gzvcf Akm.alyr.nonvariable.NoExHet.ForPi.vcf.gz --site-pi --stdout > Akm.alyr.site.pi.out

#vcftools --gzvcf Akm.ahal.nonvariable.NoExHet.ForPi.vcf.gz --window-pi 250000 --stdout > Akm.ahal.window250K.pi.out
#vcftools --gzvcf Akm.alyr.nonvariable.NoExHet.ForPi.vcf.gz --window-pi 250000 --stdout > Akm.alyr.window250K.pi.out

#vcftools --gzvcf Akm.ahal.nonvariable.NoExHet.ForPi.vcf.gz --window-pi 100000 --stdout > Akm.ahal.window.100K.pi.out
#vcftools --gzvcf Akm.alyr.nonvariable.NoExHet.ForPi.vcf.gz --window-pi 100000 --stdout > Akm.alyr.window.100K.pi.out


work_folder=$pi_folder/Pops
mkdir -p $work_folder
cd $work_folder


while read Pop; do
	
	echo $Pop
	mkdir -p $work_folder/$Pop
	cd $Pop
	echo -n > $work_folder/$Pop/$Pop.samples.list
	grep "${Pop}[0-9][0-9][0-9]" $SCRIPT_DIR/PopID.Code.list.txt >> $work_folder/$Pop/$Pop.samples.list

	#vcf extracted by each pop: Ahal 
	vcftools --gzvcf $pi_folder/Akm.ahal.nonvariable.NoExHet.ForPi.lab_edited.vcf.gz \
	 --keep $work_folder/$Pop/$Pop.samples.list --recode --recode-INFO-all --stdout | gzip > $work_folder/$Pop/Akm.ahal.$Pop.nonvariable.NoExHet.ForPi.vcf.gz
	#vcf extracted by each pop: Alyr
	vcftools --gzvcf $pi_folder/Akm.alyr.nonvariable.NoExHet.ForPi.lab_edited.vcf.gz \
	 --keep $work_folder/$Pop/$Pop.samples.list --recode --recode-INFO-all --stdout | gzip > $work_folder/$Pop/Akm.alyr.$Pop.nonvariable.NoExHet.ForPi.vcf.gz

	#estimate pi (per site): Ahal 
	vcftools --gzvcf $work_folder/$Pop/Akm.ahal.$Pop.nonvariable.NoExHet.ForPi.vcf.gz \
	 --site-pi --stdout > $work_folder/$Pop/Akm.ahal.$Pop.site.pi.out
	 sed 's/-nan/NA/g' $work_folder/$Pop/Akm.ahal.$Pop.site.pi.out > $work_folder/$Pop/Akm.ahal.$Pop.site.pi.ForR.out
	#estimate pi (per site): Alyr
	vcftools --gzvcf $work_folder/$Pop/Akm.alyr.$Pop.nonvariable.NoExHet.ForPi.vcf.gz \
	 --site-pi --stdout > $work_folder/$Pop/Akm.alyr.$Pop.site.pi.out
	 sed 's/-nan/NA/g' $work_folder/$Pop/Akm.alyr.$Pop.site.pi.out > $work_folder/$Pop/Akm.alyr.$Pop.site.pi.ForR.out

	#estimate pi (100K window): Ahal 
	vcftools --gzvcf $work_folder/$Pop/Akm.ahal.$Pop.nonvariable.NoExHet.ForPi.vcf.gz \
	 --window-pi 100000 --stdout > $work_folder/$Pop/Akm.ahal.$Pop.100K.pi.out
	#estimate pi (100K window): Alyr 
	vcftools --gzvcf $work_folder/$Pop/Akm.alyr.$Pop.nonvariable.NoExHet.ForPi.vcf.gz \
	 --window-pi 100000 --stdout > $work_folder/$Pop/Akm.alyr.$Pop.100K.pi.out

	cd $work_folder

done < $SCRIPT_DIR/pop_list.txt #list of 25 populations 



cd $SCRIPT_DIR

module unload samtools/1.10
module unload gatk/4.1.7.0
module unload vcftools/0.1.15

