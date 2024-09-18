#!/bin/bash

#threads to use for processing
THREADS=10

#start conda environment
conda activate rnaseq

#navigate to sra_out to prefetch
cd ./sra_out

#ask for singleor paired end reads
echo "Is this [single] end or [paired] end data?"
read endType
if [ "$endType" = "single" ]; then
	echo selected "single"
else if [ "$endType" = "paired" ]; then
	echo selected "paired"
else
	echo "input either [single] or [paired]"
	exit

#loop through accession list, fetch samples and fastq format them
while IFS=read -r line; do
	prefetch $line
	if [ "$endType" = "single" ]; then
		fasterq-dump $line
	fi
	if [ "$endType" = "paired" ]; then
		fasterq-dump $line --split-files --skip-technical
	fi
done < accession_list.txt

##perform quality control on each sample
#fastqc -t $THREADS -o ./qc_files ./sra_out/*.fastq
#mulitqc ./qc_files/ -o ./qc_files/

##perform rRNA removal with sortmerna <SKIPPING FOR NOW>
#<sortmerna stuff here>

##perform adapter trimming with trimmomatic <SKIPPING FOR NOW>
#<trimmomatic stuff here>

#perform alignment using hisat2
if [ "$endType" = "single" ]; then
	for file in /dir/*
	do
		hisat2 -p $THREADS -x ./hisat_ref/grch38/genome -1 ./sra_out/"$file" -S ./sam_file/"${file%.}" --new-summary 2> ./sam_file/"${file%.}_new-summary.txt"
	done
