---
title: Gencode
namespace: Gencode
description: Human gene expression associations with genetic variation. 
dependencies: 
  - name: gencode
    url: https://www.gencodegenes.org/human/
---

<a href="https://github.com/biobricks-ai/gencode/actions"><img src="https://github.com/biobricks-ai/gencode/actions/workflows/bricktools-check.yaml/badge.svg?branch=main"/></a>

# [GENCODE](https://www.gencodegenes.org/) project
>The goal of the GENCODE project is to identify and classify all gene features in the human and mouse genomes with high accuracy based on biological evidence, and to release these annotations for the benefit of biomedical research and genome interpretation.

Biobricks.ai transforms the main annotation file from the latest Gencode release into parquet files. 

# Data overview 

-This directory contains data obtained the main annotation file from Gencode. Gencode provides annotation information about genomic feature types such as genes and transcripts.
- The data is stored in parquet format. Descriptions for each column of each file can be found below.
- The data was downloaded from: https://www.gencodegenes.org/human/

# Data Table List 

- `gencode.v40.annotation.gtf.parquet`
- `gene_conversion_table_annotated.parquet`
- `gene_conversion_table.parquet`
- `transcript_conversion_table_annotated.parquet`
- `transcript_conversion_table.parquet`

# Description of Files 

### Data files

`gencode.v40.annotation.gtf.parquet`

This is the main annotation file from Gencode. The only modification to this file is the addition of column names. This file is otherwise unmodified and has been saved as a parquet.
- chromosome_name. The chromosome that the feature is found on.
- annotation_source. The source for the annotation (eg, Ensembl or Havana).
- feature_type. The type of feature (eg, gene or transcript).
- genomic_start_position. The chromosomal start position of the feature.
- genomic_end_position.  The chromosomal end position of the feature.
- score. The score column is typically included in GTF files and thus has been included by Gencode. However, in Gencode's GTF file this column does not contain any information.
- genomic_strand. The strand that the feature is found on (eg, + or -).
- genomic_phase. The genomic phase (for CDS features).
- additional_information. This column contains additional information with annotation information for the feature.

`gene_conversion_table_annotated.parquet`

This is a custom file with information about all genes included in the the latest gencode release. In this file, the additional information column has been parsed to retrieve the Ensembl gene ID, External gene name, and HGNC ID. No transcript information is included in this file. The score, genomic phase, and additional information columns have been removed.
- chromosome_name. The chromosome that the feature is found on.
- annotation_source. The source for the annotation (eg, Ensembl or Havana).
- feature_type. The type of feature (all gene in this case).
- genomic_start_position. The chromosomal start position of the feature.
- genomic_end_position.  The chromosomal end position of the feature.
- genomic_strand. The strand that the feature is found on (eg, + or -).
- ensembl_id. The Ensembl gene ID for the gene.
- external_gene_name. The external gene name for the gene.
- hgnc_id. The HGNC ID for the gene. 

`gene_conversion_table.parquet`

This is a custom file that provides the Ensembl gene ID, external gene name, and HGNC ID for all genes included in the latest Gencode release. All other information has been removed and no transcript information has been included.
- ensembl_id. The Ensembl gene ID for the gene.
- external_gene_name. The external gene name for the gene.
- hgnc_id. The HGNC ID for the gene. 

`transcript_conversion_table_annotated.parquet`

This is a custom file with information about all transcripts included in the the latest gencode release. In this file, the additional information column has been parsed to retrieve the Ensembl gene ID, External gene name, HGNC ID, and Ensembl transcript ID for each transcript. The score, genomic phase, and additional information columns have been removed. The feature type for all entries in this file is transcript.
- chromosome_name. The chromosome that the feature is found on.
- annotation_source. The source for the annotation (eg, Ensembl or Havana).
- feature_type. The type of feature (all transcript in this case).
- genomic_start_position. The chromosomal start position of the feature.
- genomic_end_position.  The chromosomal end position of the feature.
- genomic_strand. The strand that the feature is found on (eg, + or -).
- ensembl_id. The Ensembl gene ID for the gene that the transcript is found in. 
- transcript_id. The Ensembl transcript ID for the transcript for the gene that the transcript is found in.

`transcript_conversion_table.parquet`

This is a custom file with information about the Ensembl gene ID and transcript ID for all transcripts included in the latest gencode release. The only two columns in thsi file are Ensembl gene ID and Ensembl transcript ID. This file is intended to map transcripts to the genes that they are found in. 
- transcript_id. The Ensembl transcript ID for the transcript for the gene that the transcript is found in.
- ensembl_id. The Ensembl gene ID for the gene that the transcript is found in. 

## Data can be downloaded using the following commands. To retrieve the data, make sure that dvc is downloaded

**Retrieving a single file**
```
dvc get git@github.com:insilica/oncindex-bricks.git bricks/gencode/data/gene_conversion_table.parquet -o data/gene_conversion_table.parquet
```
**It is advised to import files into a project so that you will be able to track changes in the data set**
```
dvc import git@github.com:insilica/oncindex-bricks.git bricks/gencode/data/ -o data
```

