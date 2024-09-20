#!/bin/bash

echo "How many threads do you want to use?"
read THREADS

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

#needed for a weird windows bug despite wsl. Windows appends a \r after each line in a txt file???
sed -i 's/\r$//' accession_list.txt

#loop through accession list, fetch samples and fastq format them
while IFS="" read -r line || [ -n "$line" ]; do
    echo "Processing $line"
    if [ "$endType" = "single" ]; then
        fasterq-dump $line --progress --threads $THREADS 
    elif [ "$endType" = "paired" ]; then
        fasterq-dump $line --split-files --skip-technical --progress --threads $THREADS
    fi
done < accession_list.txt

#gzip all fastq files generated
echo "Gzipping all fastq files"
gzip --verbose *.fastq

#navigate back to the main directory
cd ..

#quantify expression using salmon
#loop through the fastq.gz files and quantify expression, checking for single or paired end reads
echo "Quantifying expression with Salmon"
if [ "$endType" = "single" ]; then
    for file in ./sra_out/*.fastq.gz; do
        echo "Processing $file"
        salmon quant -p $THREADS -i ./salmon_ref/salmon_index --geneMap ./salmon_ref/mappings.gtf --validateMappings -l A -r ./sra_out/"$file" -o ./salmon_gene_counts/"$(basename "$file" .fastq.gz)"
    done
elif [ "$endType" = "paired" ]; then
    for file in ./sra_out/*_1.fastq.gz; do
        echo "Processing $file"
        base=$(basename "$file" _1.fastq.gz)
        salmon quant -p $THREADS -i ./salmon_ref/salmon_index --geneMap ./salmon_ref/mappings.gtf --validateMappings -l A -1 ./sra_out/"${base}_1.fastq.gz" -2 ./sra_out/"${base}_2.fastq.gz" -o ./salmon_gene_counts/"${base}"
    done
fi
