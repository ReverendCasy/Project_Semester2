library(dplyr)
library(sleuth)
library(biomaRt)
library(ggplot2)
library(biomaRt)

default <- read.table('/home/reverend_casy/Project/for_phantasus.tsv', header = T) #141360 rows

subbing <- read.table('/home/reverend_casy/Project/for_phantasus_non_zero.tsv', header = T) #141360 rows
row_sub = apply(subbing[,-1], 1, function(row) all(row > 0.0 ))
logging <- subbing[row_sub,] #36398 rows

logging[,2:15] <- log2(logging[,2:15])
morethanone <- logging[apply(logging[,-1], 1, function(row) all(row > 1.0 )),] #14381 rows

write.table(morethanone, file = '/home/reverend_casy/Project/for_phantasus_log2_transformed_more_than_one.tsv', sep='\t',row.names = T, col.names = T)
View(morethanone[,1])

p005 <- read.table('/home/reverend_casy/Project/p005comparison.csv', header = T)
View(p005)
ncol(p005)


diffexp <- read.table('/home/reverend_casy/Project/p005comparison.csv',header = T)
View(diffexp)
mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                dataset = "hsapiens_gene_ensembl",
                host = 'www.ensembl.org')
t2g <- getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
                            "external_gene_name"), mart = mart)
t2g <- rename(t2g, target_id = ensembl_transcript_id,
              ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
write.table(diffexp, file='/home/reverend_casy/Project/p005comparison_names.csv', sep = '\t')
View(diffexp)
ncol(diffexp)
length(diffexp[,15])
length(unique(diffexp[,15]))
unique(diffexp[,15])
new_diffexp <- diffexp %>% group_by(ext_gene) %>% mutate(transcr)
View(new_diffexp)
