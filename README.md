# Post-QC
Post variant-calling QC pipeline for orienting cohort data with a reference file. An additional step for merging, phasing jointly with a reference panel, and running local ancestry inference is also included. Both steps are implemented as automated scripts that can be called with bash. Subscripts are in python.        



Dependencies:
Programs need to be on the path.
Step 1 (cohort data post-QC and/or merging):
     python. Plus modules: pandas, numpy, argparser
     PLINK 

Step 2: (phasing)
     PLINK
     SHAPEIT2
     VCFtools
     RFmix


Detailed description of STEP 1: Cohort Data Post-QC and harmonization with a reference panel
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

Though this has been tested with 1000G, any reference panel in legend format should work.

Usage:

Lauch step 1, data QC and harmonization:  
```sh CohortDataQC_final.sh <pink binary file stem> <dbSNP-bedfile> <ref-panel-legend, i.e. from 1kG> ```

Output is suffixed with .QCed

STEP 2: Merging and phasing.

Post-QC'ed cohort data is then intersected and jointly phased with a user-specified reference panel of individuals. When merging, the script documents and removes any remaining conflicting and multi-allelic sites. The merged dataset is then filtered to include only informative SNPs present in both the cohort data and the reference panel using a minor allele frequency filter of 0.5% and a genotype missingness cutoff of 90%. The program Shapeit2 (O’Connell et al., 2014) is used to phase each chromosome separately, informed by a recombination map that is expected to be in the format of the HapMap combined b37 recombination map (The International HapMap Consortium 2005). This merged, filtered, phased data is then fed into RFmix with a user specified reference individual map file, as required by RFmix. Detailed desciption of this file is in the RFmixv2 manual (https://github.com/slowkoni/rfmix/blob/master/MANUAL.md). Some manual processing of recombination map files may be required depending on the original format of the file used. 

Usage:
Launch step 2:  
```sh Merge_Phase_RFmix.sh <data-stem> <ref-stem> <genetic-recomb-map> <ancestry-ref-map> ``` 

Output will be in haps/sample format from SHAPEIT2, followed by local ancestry calls from RFMix.

