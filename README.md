# Identification of all-type RNAs in human transcriptome via Illumina and Nanopore platforms
### *recently changed to:*
# Analysis of hypoxia effect on PBML cell transcriptome relating to exercise stress
*Yury V. Malovichko, Andrey S. Glotov*

## Abstract



## 2. Materials and Methods

## 2.1. Source data
PBML transcriptome was extracted and purified from mRNA with GLOBINclear Kit, huan for globin mRNA depletion. Purified total mRNA library was processed with TruSeq Stranded mRNA libraries (Illumina) as a plus-stranded library. Reads were indexed with AR001 index for pre-exercise assay (5'-ATCACG (A)-3') and AR003 for -post-exercise assay (5'-TTAGGC  (A)-3') assay.  Sequencing was performed on Illumina HiSeq 4000 in pair-end mode with single read length of 150 nucleotides. 

## 2.2. Quality control
Read quality was assessed via FastQC v.0.11.7. In the overall, all four fastq files demonstrated same problems, such as duplication content and per tile quality distortion. Soft trimming was performed in Trimmomatic v.0.36. to get rid of indices. Processed library will be inspected for strand alignment for example, in Trinity, but for now only raw assessment inferred from Kallisto quantificatin has been obtainded.

## 2.3. Alignmnent onto reference genome
For genome alignmnent, we chose GRCh38 version of human genome assembly. We tried to index reference genome with STAR-2.5.3a. for future alignmnent with the same tool but met harsh requirements for both RAM and storage memory and now expect to perform same operations on Biobanc server.

## 2.4. Quantification and globin search
To quantify transcripts from unassembled reads we used Kallisto v.0.44.0. with hg19 chosen as reference transcriptome. Resulting tsv files were sorted by *tpm* value (column 5) in the decreasing order, after which were subsetted by 30 first entries and written into new txt files. Ensembl transcript ID were changed for NCBI Gene symbols or Info entries via bioDB:db2db online tool. For minus strand transcripts, alternative names were searched for manually.

## 2.5. Differential expression assessment and evaluation
Kallisto output files were used for differential expression in R (*sleuth* package). However, we initially failed to test any hypothesis because of absence of any replicates for both pre-exercise and and post-exercise assays.
