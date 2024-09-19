#!/bin/bash

#threads to use for processing
THREADS=10

#start conda environment
conda init --all
conda activate rnaseq_featureCount

#navigate to sra_out to prefetch
cd ./salmon_gene_counts/sra_out

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

#loop through accession_list.txt, fetch samples and fastq format them
while IFS=read -r line; do
	prefetch $line
	if [ "$endType" = "single" ]; then
		fasterq-dump $line
	elif [ "$endType" = "paired" ]; then
		fasterq-dump $line --split-files --skip-technical
	fi
done < accession_list.txt

#navigate back to the main directory
cd ..

##perform quality control on each sample
#fastqc -t $THREADS -o ./qc_files ./sra_out/*.fastq
#mulitqc ./qc_files/ -o ./qc_files/

##perform rRNA removal with sortmerna <SKIPPING FOR NOW>
#<sortmerna stuff here>

##perform adapter trimming with trimmomatic <SKIPPING FOR NOW>
#<trimmomatic stuff here>

#perform alignment using hisat2 and output sam files, checking for single or paired end reads
#if single end reads, simply loop through the files
#if paired end reads, loop through only the first file and use the second file as the second input
if [ "$endType" = "single" ]; then
	for file in ./sra_out/*.fastq; do
		hisat2 -p $THREADS -x ./hisat_ref/grch38/genome -U "$file" -S ./sam_file/"$(basename "$file" .fastq).sam" --new-summary 2> ./sam_file/"$(basename "$file" .fastq)_new-summary.txt"
	done
elif [ "$endType" = "paired" ]; then
	for file in ./sra_out/*_1.fastq; do
		base=$(basename "$file" _1.fastq)
		hisat2 -p $THREADS -x ./hisat_ref/grch38/genome -1 ./sra_out/"${base}_1.fastq" -2 ./sra_out/"${base}_2.fastq" -S ./sam_file/"${base}.sam" --new-summary 2> ./sam_file/"${base}_new-summary.txt"
	done
fi

#convert sam files to bam files and deposit in bam_files
for file in ./sam_file/*.sam; do
	samtools view -@ $THREADS -bS "$file" -o ./bam_file/"$(basename "$file" .sam).bam"
done

#sort bam files and deposit in sorted_bam_files
for file in ./bam_file/*.bam; do
	samtools sort -@ $THREADS "$file" -o ./sorted_bam_files/"$(basename "$file" .bam)_sorted.bam"
done

##count reads using featureCounts for all sorted bam files using the gtf annotation file
#if [ "$endType" = "single" ]; then
#	for file in ./sorted_bam_files/*_sorted.bam; do
#		featureCounts -T $THREADS -a ./hisat_ref/Homo_sapiens.GRCh38.112.gtf -o ./gene_counts/gene_counts.txt $file
#	done
#fi
#if [ "$endType" = "paired" ]; then
#	for file in ./sorted_bam_files/*_sorted.bam; do
#		featureCounts -T $THREADS -a ./hisat_ref/Homo_sapiens.GRCh38.112.gtf -o ./gene_counts/gene_counts.txt
#	done
#fi