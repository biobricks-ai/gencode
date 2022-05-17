# This script parses the gencode GTF and saves it as parquet files
library(data.table)
library(arrow)
library(dplyr)
library(tidyr)

# This function gets the IDs from the gencode file
get_gene_IDs <- function(line) {
	split = unlist(strsplit(line, ";"))
	ensembl = split[grepl(split, pattern="gene_id")] |> sub(pattern = "gene_id \"", replacement = '') |> sub(pattern = "[.][0-9]+\"", replacement = "")
	external_gene_name = split[grepl(split, pattern="gene_name")] |> sub(pattern = " gene_name \"", replacement = '') |> gsub(pattern = "\"", replacement = "")
	hgnc_id = split[grepl(split, pattern="hgnc_id")] |> sub(pattern = " hgnc_id \"HGNC:", replacement = '') |> sub(pattern = "\"", replacement = "")
	paste(ensembl, external_gene_name, hgnc_id, sep = ';')
}

get_transcript_ID <- function(line) {
	split = unlist(strsplit(line, ";"))
	ensembl = split[grepl(split, pattern="gene_id")] |> sub(pattern = "gene_id \"", replacement = '') |> sub(pattern = "[.][0-9]+\"", replacement = "")
	transcript_id = split[grepl(split, pattern="transcript_id")] |> sub(pattern = " transcript_id \"", replacement = '') |> sub(pattern = "[.][0-9]+\"", replacement = "")
	paste(ensembl, transcript_id, sep = ";")
}

out = "data/"
fs::dir_create(out)
files = list.files("cache/")
gencode_file = files[grepl(files, pattern = "gencode.v[0-9]+.annotation.gtf.gz")] |> fs::path_ext_remove()
gencode = fread(paste0("cache/", gencode_file, ".gz"), sep = '\t') 

#### Save gencode file after just adding column names as parquet 
colnames(gencode) <- c("chromosome_name", "annotation_source", "feature_type", "genomic_start_position", "genomic_end_position", "score", "genomic_strand", "genomic_phase", "additional_information")
write_parquet(gencode, paste0(out, gencode_file, ".parquet"))

#### Parse out the ensembl gene ID, external gene name, and hgnc id 
gene_conversion_table_annotated <- gencode |> filter(feature_type == "gene") |> 
	mutate(gene_ids = get_gene_IDs(additional_information)) |>
	separate(col=gene_ids, into=c("ensembl_id", "external_gene_name", "hgnc_id"), sep = ";") |>
	select(-one_of(c("score", "genomic_phase", "additional_information")))

write_parquet(gene_conversion_table_annotated, sink=paste0(out, "gene_conversion_table_annotated.parquet"))

#### Save a light version that does not have any of the genomic anonotation information. This version of the file is intended for people to convert between external gene name, ensembl ID, and hgnc ID
gene_conversion_table_no_annotation <- gene_conversion_table_annotated |> select(ensembl_id, external_gene_name, hgnc_id)
write_parquet(gene_conversion_table_no_annotation, sink=paste0(out, "gene_conversion_table.parquet"))

#### Parse to match transcript ID to ensembl ID
transcript_conversion_table_annotated <- gencode |> filter(feature_type == "transcript") |> 
	mutate(transcript_ids = get_transcript_ID(additional_information)) |>
	separate(col=transcript_ids, into=c("ensembl_id", "transcript_id"), sep = ";") |>
	select(-one_of(c("score", "genomic_phase", "additional_information")))

write_parquet(transcript_conversion_table_annotated, sink=paste0(out, "transcript_conversion_table_annotated.parquet"))

#### Save a light version that only maps transcript ID to ensembl ID 
transcript_conversion_table <- transcript_conversion_table_annotated |> select(transcript_id, ensembl_id)
write_parquet(transcript_conversion_table, paste0(out, "transcript_conversion_table.parquet"))











