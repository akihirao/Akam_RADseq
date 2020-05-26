# Polymorphism analysis in the allopolyploid model plant <i>Arabidopsis kamchatica</i>
Bioinformatics pipeline for variant calling workflow in RAD-seq of <i>Arabidopsis kamchatica</i>
 


## Requirement

* samtools: Tools for manipulating NGS data (https://github.com/samtools/samtools)
* vcftools: A set of tools for working with VCF files (https://github.com/vcftools/vcftools)
* BWA: Burrow-Wheeler Aligner (http://bio-bwa.sourceforge.net) 
* gatk: Genome Analysis Toolkit (https://gatk.broadinstitute.org/)
* EAGLE: Explicit Alternative Genome Likelihood Evaluator (https://github.com/tony-kuo/eagle)


The environment under Ubuntu 18.04 is tested. The versions of tools used are documented in a series of shell scripts.

## Reference genomes
<i>Arabidopsis kamchatica</i> is a allotetraploid derived from the two diploid species <i>A. halleri</i> (particularly subsp. <i>gemmifera</i> distributed in East Asia) and <i>A. lyrata</i> (particularly subsp. <i>petraea</i> from Far East Russia). <i>Arabidopsis halleri</i> reference genome is from Briskine et al. 2016; <i>A. lyrata</i> reference genome is from Paape et al. 2018. 

Paape T. et al. (2018) Patterns of polymorphism and selection in the subgenomes of the allopolyploid <i>Arabidopsis kamchatica</i>. Nature communications. 2018 Sep 25;9(1):3909. https://doi.org/10.1038/s41467-018-06108-1

Briskine, R. V. et al. (2016) Genome assembly and annotation of <i>Arabidopsis halleri</i>, a model for heavy metal hyperaccumulation and evolutionary ecology. Molecular Ecology. Resources 5: 1025–1036.  https://doi.org/10.1111/1755-0998.12604


## Flowchart
 
Install Pyxel with pip command.
 
```bash
pip install pyxel
```



## Usage
Run a series of the shell scripts in the order listes after changing paths according to your environemt:
 
```bash
Pipe.01.BWA_mapping.sh
Pipe.02.eagle_rc.sh
Pipe.03.BamFiltering.sh
...
Pipe.10.GenotypeFiltering.sh
```



## Note
 

