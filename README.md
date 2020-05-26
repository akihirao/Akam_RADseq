# Polymorphism analysis in the allopolyploid model plant <i>Arabidopsis kamchatica</i>
Bioinformatics pipeline for variant calling workflow in RAD-seq of <i>Arabidopsis kamchatica</i>
 


# Requirement

* samtools: Tools for manipulating NGS data (https://github.com/samtools/samtools)
* vcftools: A set of tools for working with VCF files (https://github.com/vcftools/vcftools)
* BWA: Burrow-Wheeler Aligner (http://bio-bwa.sourceforge.net) 
* gatk: Genome Analysis Toolkit (https://gatk.broadinstitute.org/)
* EAGLE: Explicit Alternative Genome Likelihood Evaluator (https://github.com/tony-kuo/eagle)


The environment under Ubuntu 18.04 is tested. The versions of tools used are documented in a series of shell scripts.



# Flowchart
 
Install Pyxel with pip command.
 
```bash
pip install pyxel
```



# Usage
Run a series of the shell scripts in the order listes after changing paths according to your environemt:
 
```bash
Pipe.01.BWA_mapping.sh
Pipe.02.eagle_rc.sh
Pipe.03.BamFiltering.sh
...
Pipe.10.GenotypeFiltering.sh
```



# Note
 

