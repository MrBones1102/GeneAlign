#!/bin/bash

#threads to use for processing
THREADS=10

#start conda environment
conda init --all
conda activate rnaseq_salmon

#check to make sure the salmon_gene_counts directory exists (setup_salmon.sh should have created it)
if [ ! -d "./salmon_processing" ]; then
    echo "salmon_processing directory not found. Please run setup_salmon.sh first"
    exit 1
fi

#navigate to sra_out to prefetch
cd ./salmon_processing/sra_out

#ask for single or paired end reads
echo "Is this [single] end or [paired] end data?"
read endType
if [ "$endType" = "single" ]; then
    echo "selected [single]"
elif [ "$endType" = "paired" ]; then
    echo "selected [paired]"
else
    echo "input either [single] or [paired]"
    exit 1
fi

#loop through accession list, fetch samples and fastq format them
while IFS="" read -r p || [ -n "$line"]; do
    prefetch $line
    if [ "$endType" = "single" ]; then
        fasterq-dump $line
    elif [ "$endType" = "paired" ]; then
        fasterq-dump --split-files --skip-technical $line
    fi
done < accession_list.txt

#gzip all fastq files generated
gzip *.fastq

#navigate back to the main directory
cd ..

#quantify expression using salmon
#loop through the fastq.gz files and quantify expression, checking for single or paired end reads
if [ "$endType" = "single" ]; then
    for file in ./sra_out/*.fastq.gz; do
        salmon quant -p $THREADS -i ./salmon_ref/salmon_index --geneMap ./salmon_ref/mappings.gtf --validateMappings -l A -r "$file" -o ./salmon_gene_counts/"$(basename "$file" .fastq.gz)"
    done
elif [ "$endType" = "paired" ]; then
    for file in ./sra_out/*_1.fastq.gz; do
        base=$(basename "$file" _1.fastq.gz)
        salmon quant -p $THREADS -i ./salmon_ref/salmon_index --geneMap ./salmon_ref/mappings.gtf --validateMappings -l A -1 ./sra_out/"${base}_1.fastq.gz" -2 ./sra_out/"${base}_2.fastq.gz" -o ./salmon_gene_counts/"${base}"
    done
fi
