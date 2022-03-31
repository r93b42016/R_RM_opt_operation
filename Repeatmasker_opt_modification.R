install.packages("biomartr", dependencies = TRUE)

library(biomartr)
library(dplyr)

setwd("C:\\Users\\r93b4\\Desktop\\Myprojects\\2nd_altricial_precocial_study\\make_blacklist_ZF")
getwd()

input_out <- read_rm(file.choose())
head(input_out)

##optional:input assembly_report for chr name change 
input_assembly_report <- read.table(file.choose(),sep="\t")
head(input_assembly_report)
#optional 
chr_qry_id <- subset(input_assembly_report, select=c(V3,V7))
head(chr_qry_id)
colnames(chr_qry_id)<-c("chr","qry_id")
head(chr_qry_id)
#optional
merge<-merge(input_out,chr_qry_id,by="qry_id")
head(merge)
tail(merge)

#write results without row, column names, and quotes
write.table(merge,file="GCF_003957565.2_bTaeGut1.4.pri_genomic.fna.out.chr.csv",sep=",", col.names = T, row.names = F,quote = FALSE)

input_chr_out <- read.table(file.choose(),header=T,sep=",")
head(input_chr_out)

##keep or remove repeats##
#https://www.statology.org/filter-rows-that-contain-string-dplyr/
#keep rows that contain '???' or '???' in the player column
result_keep_Repeat<- input_out %>% filter(grepl('Low_complexity|rRNA|Satellite|scRNA|Simple_repeat', matching_class))
head(result_keep_Repeat)

#keep rows that contain '???' or '???' in the player column
result_keep_Repeat<- input_out %>% filter(grepl('DNA|LTR|SINE|LINE', matching_class))
head(result_keep_Repeat)

#remove rows that contain '???' or '???' in the player column
result_rm_sRepeat<- input_chr_out %>% filter(!grepl('Low_complexity|rRNA|Satellite|scRNA|Simple_repeat', matching_class))
head(result_rm_sRepeat)

#make bed file
output <- subset(result_keep_Repeat, select = c(qry_id,qry_start,qry_end,matching_class,qry_width))
head(output)

#write out bed format
write.table(output,file="GG6_blacklist.bed",sep="\t", col.names = F, row.names = F,quote = FALSE)
