library(dplyr)
library(sleuth)
library(biomaRt)

sample_id <- dir(file.path("C:/Users/user/Desktop/heh/kallisto_ref"))
kal_dirs <- file.path("C:/Users/user/Desktop/heh/kallisto_ref", sample_id)
s2c <-  read.table("C:/Users/user/Desktop/heh/metadata.txt",header = TRUE, stringsAsFactors=FALSE) %>% 
  mutate(path=kal_dirs)


mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                         dataset = "hsapiens_gene_ensembl",
                         host = 'www.ensembl.org')
t2g <- getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
                                     "external_gene_name"), mart = mart)
t2g <- rename(t2g, target_id = ensembl_transcript_id,
                     ens_gene = ensembl_gene_id, ext_gene = external_gene_name)

so <- sleuth_prep(s2c, target_mapping = t2g, extra_bootstrap_summary = FALSE)
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')
models(so)
sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_p005 <- sleuth_table %>% filter(qval <= 0.05)

sleuth_p001 <- sleuth_table %>% filter(qval <= 0.01)
sleuth_p0001<- sleuth_table %>% filter(qval <= 0.001)

#sample_writing
write.table(sleuth_p005_s, file = "C:/Users/user/Desktop/heh/IB/Semester2/Project/p005comparison_subsets.csv",
          sep = '\t')
read.table("C:/Users/user/Desktop/heh/IB/Semester2/Project/p005comparison_subsets.csv", sep = '\t')

#density_plot
dens <- plot_group_density(so, use_filtered = TRUE, units = "tpm",
                           trans = "log", grouping = setdiff(colnames(so$sample_to_covariates),
                                                             "sample"), offset = 1)

#does not work for somehow
plot_bootstrap(so, "ENST00000264716.8", units = "est_counts", color_by = "condition")
apply(c(sleuth_p005[,1][1:20]),1, function(y) plot_bootstrap(so, y, units = "est_counts", color_by = "condition") )



#subsets

sample_id_s <- dir(file.path("C:/Users/user/Desktop/heh/IB/Semester2/Project/new_subsets"))
kal_dirs_s <- file.path("C:/Users/user/Desktop/heh/IB/Semester2/Project/new_subsets", sample_id)
s2c_s <-  read.table("C:/Users/user/Desktop/heh/metadata.txt",header = TRUE, stringsAsFactors=FALSE) %>% 
  mutate(path=kal_dirs_s)
so_s <- sleuth_prep(s2c, target_mapping = t2g, extra_bootstrap_summary = FALSE)
so_s <- sleuth_fit(so, ~condition, 'full')
so_s <- sleuth_fit(so, ~1, 'reduced')
so_s <- sleuth_lrt(so, 'reduced', 'full')
models(so_s)
sleuth_table_s <- sleuth_results(so_s, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_p005_s <- sleuth_table_s %>% filter(qval <= 0.05)

sleuth_p001_s <- sleuth_table_s %>% filter(qval <= 0.01)
sleuth_p0001_s<- sleuth_table_s %>% filter(qval <= 0.001)
dens_s <- plot_group_density(so_s, use_filtered = TRUE, units = "tpm",
                           trans = "log", grouping = setdiff(colnames(so$sample_to_covariates),
                                                             "sample"), offset = 1)

#concatenation
full <- sapply(kal_dirs, function(x) paste(x,'/abundance.tsv', sep = '')) %>%
  sapply(function(x) read.csv(x, sep='\t')) %>% sapply(function(x) rbind.data.frame(x))
 write.table(full, file = "C:/Users/user/Desktop/heh/IB/Semester2/Project/concatenated_raw.tsv",
            sep = '\t')

 paste_full <- sapply(kal_dirs, function(x) paste(x,'/abundance.tsv', sep = '')) %>%
   sapply(function(x) read.csv(x, sep='\t')) %>% sapply(function(x) paste(x, sep='\n'))
 write.table(paste_full, file = "C:/Users/user/Desktop/heh/IB/Semester2/Project/concatenated_paste.tsv",
             sep = '\t')
 structure(full)
 