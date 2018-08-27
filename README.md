# Post-QC
Post variant-calling QC pipeline for orienting cohort data with a reference file. An additional step for merging and phasing jointly with a reference panel is also included. Both steps are implemented as automated scripts that can be called with bash. The main code is in bash, optimized for a module-based system (such as Lisa), but can be quickly modified for use in most environments. Subscripts are in python.        



Dependencies:
Programs need to be on the path.
Step 1 (cohort data post-QC and/or merging):
     python. Plus modules: pandas, numpy, argparser
     PLINK 

Step 2: (phasing)
     PLINK
     SHAPEIT2


Detailed description of STEP 1: Cohort Data Post-QC
Post-variant calling QC to clean and consistently prepare the data for downstream analysis. The steps conducted, in order, are as follows:
1.	Extract only autosomes in data file 
2.	Find and get rid of duplicate loci
3.	Update SNP IDs to dbsnp 144 (Sherry et al., 2001)
4.	Orient data to 1000 genome reference. This involves 3 substeps:
     a.	Find and remove indels
     b.	Find and remove loci not found in 1000 genome, or that have different coding alleles than 1000 genome (tri-allelic, for example)
     c.	Flip alleles that are on the wrong strand
5.	Remove A/T, G/C loci

This script also outputs warnings if more than 2% of sites are incongruous between the input dataset and 1000G locations. A large discrepancy in SNP physical locations can occur if the datasets are on different reference builds. A/T and G/C loci are unable to be strand-resolved and for this are routinely removed.

Though this is hard-coded for 1000G, any reference panel legend file should work if substituted in. Currently, users will have to modify the code with a legend file in their own directory.


STEP 2: Data harmonization and phasing
Post-QC'ed cohort data is then intersected and jointly phased with a user-specified reference panel of individuals. When merging, the scripts documents and removes many remaining onflicting and multi-allelic sites. The merged dataset is then filtered to include only informative SNPs present in both the cohort data and the reference panel using a minor allele frequency filter of 0.5% and a genotype missingness cutoff of 90%. The program Shapeit2 (O’Connell et al., 2014) is used to phase each chromosome separately, informed by the HapMap combined b37 recombination map (The International HapMap Consortium 2005). Users will need to change the path to the recombination map used to reflect its present in their directories. 




Usage:

Lauch step 1:  sh CohortDataQC_final.sh <pink binary file stem>. 
     Output is suffixed with .QCed


Launch step 2:  sh CohortDataQC_mergephase.sh <plink binary file stem>. 
     output is in haps/sample format from SHAPEIT2
     

An additional script to process output files and run Local Ancestry Inference (using RFmix) is also provided, should ancestry deconvolution be required.
Usage: sh PrepandrunRFmix_2way.sh <file stem name>
