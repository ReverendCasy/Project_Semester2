# Identification of all-type RNAs in human transcriptome via Illumina and Nanopore platforms
### *recently changed to:*
# Analysis of hypoxia effect on PBML cell transcriptome relating to exercise stress
*Yury V. Malovichko, Andrey S. Glotov*

## Abstract

Though mononuclear lymphocytes comprise but a minority of peripheral blood cells, they are utterly important for both innate and acquired immunity functioning. In the present work, we aim to expose cumulative effect of hypoxia and physical training on lymphocyte physiology by means of RNAseq assay. Default material was collected from 7 Olympics skaters who were training in the mountainous area at decent altitude either berfore or after training. The goals of the project are:

+ perform basic quality control operations over transcriptomes in question;
+ assess differential expression via kallisto tool;
+ visulize results of differential expression;
+ perform GO enrichment analysis;
+ find any biological sense in resulting transcript, gene and GO lists.


## 2. Materials and Methods

### 2.1. Source data
PBML transcriptome was extracted and purified from mRNA with GLOBINclear Kit, huan for globin mRNA depletion. Purified total mRNA library was processed with TruSeq Stranded mRNA libraries (Illumina) as a plus-stranded library. Reads were indexed with AR001 index for pre-exercise assay (5'-ATCACG (A)-3') and AR003 for -post-exercise assay (5'-TTAGGC  (A)-3') assay.  Sequencing was performed on Illumina HiSeq 4000 in pair-end mode with single read length of 150 nucleotides. 

### 2.2. Quality control
Read quality was assessed via FastQC v.0.11.7. In the overall, all four fastq files demonstrated same problems, such as duplication content and per tile quality distortion. Soft trimming was performed in Trimmomatic v.0.36. to get rid of indices. Processed library will be inspected for strand alignment for example, in Trinity, but for now only raw assessment inferred from Kallisto quantificatin has been obtainded.

### 2.3. Alignmnent onto reference genome
For genome alignmnent, we chose GRCh38 version of human genome assembly. We tried to index reference genome with STAR-2.5.3a. for future alignmnent with the same tool but met harsh requirements for both RAM and storage memory and now expect to perform same operations on Biobanc server.

### 2.4. Quantification and globin search
To quantify transcripts from unassembled reads we used Kallisto v.0.44.0. with hg19 chosen as reference transcriptome. Resulting tsv files were sorted by *tpm* value (column 5) in the decreasing order, after which were subsetted by 30 first entries and written into new txt files. Ensembl transcript ID were changed for NCBI Gene symbols or Info entries via bioDB:db2db online tool. For minus strand transcripts, alternative names were searched for manually.
After 6 new assays have been obtained, new *kallisto quant* round has been performed with number of bootstrap replicas equal 50 (see *kallisto_script.sh*). Results were also subsetted for top 50 most abundant transcripts (see *subsetting_script.sh*).

### 2.5. Differential expression assessment and evaluation
Kallisto output files were used for differential expression in R (*sleuth* package). First, a metadata file was created. Since there was no ready metadata available, we used only one factor (pre/post-excercise condition) for following model fitting. All transcripts were allocated respective Ensembl gene IDs and trivial names with *biomaRt* package. Model was built ad fitted as stated in *sleuth_script.R*. Resulting model output was sorted for entries with p-value < 0.05. As a result, 137 transcripts belonging to 118 genes were discovered to be statistically different in their transcription (see file attached). For several data operations we also performed same operations against top-50 subsets,

### 2.6. Visualization
#### 2.6.1. *Phantasus* and abundance lists
Native abundance lists were used for *Phantasus* online tool heatmap building (see *paster.sh* script). However, resulting pictures were found to be way too large for further downloading. Thus, transcript TPM values were log2-transformed and subsetted by value greater than 1 (see *for_phantasus.R* script). Nonetheless, this still was more than plausible for heatmap and PCA handling, so that we performed same operations over a top-50 list (see picture attached).
#### 2.6.2. PCA plots and density plots
Density plot has been perfromed for *sleuth* resulting model. PCA pots in *sleuth* have been built for native models. Unlike this, *Phantasus* PCAs were based on top-50 subsets. Results (see pictures attached). These pictures showed suspicious clusterization that implies that basically donor effect may have been proposed to be necessary for our initial model.

### 2.7. Script summary
+ [paster.sh](https://github.com/PreacherCasy/Project_Semester2/blob/master/paster.sh): concatenates TPMs of similar transcripts from different abundance lists;
+ [kallisto_script.sh](https://github.com/PreacherCasy/Project_Semester2/blob/master/kallisto_script.sh): automatizesmultiple *kallisto* runs for different datasets;
+ [subsetting_script.sh](https://github.com/PreacherCasy/Project_Semester2/blob/master/subsetting_script.sh): makes subsets of sorted abundance lists;
+ [sleuth_script.sh](https://github.com/PreacherCasy/Project_Semester2/blob/master/sleuth_script.R): a basic script for *sleuth* differential expression analysis. Also, contains figure-producing commands;
+ [for_phantasus.R](https://github.com/PreacherCasy/Project_Semester2/blob/master/for_phantasus.R): concatenates abundance lists for further *Phantasus* visualization

## Results 
### Differentially expressed genes
[137 transcripts belonging to 118 genes] (https://github.com/PreacherCasy/Project_Semester2/blob/master/p005comparison.tsv) were found to be differentially expressed between two physiological conditions with cutoff baseline of p < 0.05.

### Sample clusterization 
![Phantasus PCA mapped by top 50 transcript subsets](https://github.com/PreacherCasy/Project_Semester2/blob/master/Phantasus_PCA_Top_50.png) 
![Condition-dependent PCA in sleuth](https://github.com/PreacherCasy/Project_Semester2/blob/master/condition_PCA_sleuth.jpg) 
![Sample-dependent PCA in sleuth](https://github.com/PreacherCasy/Project_Semester2/blob/master/sample_PCA_sleuth.jpg) 

### Transcript density plot
![Density plot](https://github.com/PreacherCasy/Project_Semester2/blob/master/density_plot.jpg) 
