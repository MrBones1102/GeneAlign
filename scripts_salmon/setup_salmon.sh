#!/bin/bash

#ask to set install conda
echo "Do you need to install conda? [y/n]"
read installConda

if ["$installConda" = "y"]; then
    #make a conda install folder, download the setup shell script, run the script, remove the script
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
fi

#create a new environment for RNAseq analysis
conda init --all
conda create --name rnaseq_salmon

#activate the newly created environment
conda activate rnaseq_salmon

#add the required channels for packages, as required by bioconda
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

#add the required tools
conda install salmon
conda install sra-tools=3.1.0

#setup main directory and enter it
mkdir salmon_processing
cd salmon_processing

#setup SRA-Tool's working directory [this does not work this way, it will just prefetch to the current directory, change later]
mkdir sra_out
cd ./sra_out
vdb-config --prefetch-to-cwd
cd ..

#decoy-aware index and annotation generation
#set up salmon reference transcriptome by downloading the human coding transcriptome
mkdir salmon_ref
cd ./salmon_ref
#grab the human transcriptome and genome, make a decoy.txt file, and concatenate the transcriptome and genome
curl https://ftp.ensembl.org/pub/release-112/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz -o human_transcripts.fa.gz
curl https://ftp.ensembl.org/pub/release-112/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz -o human_genome.fa.gz
grep "^>" <(gunzip -c human_genome.fa.gz) | cut -d " " -f 1 > decoys.txt
sed -i.bak -e 's/>//g' decoys.txt
cat human_transcripts.fa.gz human_genome.fa.gz > human_gentrome.fa.gz
#make a decoy-aware index by salmon indexing while providing the decoy.txt
salmon index -t gentrome.fa.gz -d decoys.txt -p $THREADS -i salmon_index

#grab the transcripts -> gene mapping file
curl https://ftp.ensembl.org/pub/release-112/gtf/homo_sapiens/Homo_sapiens.GRCh38.112.gtf.gz -o mappings.gtf.gz
gzip -d mappings.gtf.gz

#go back to the main dir
cd ..

exit 0
##UC Davis version
#zcat human_transcripts.fa.gz |zcat - human_genome.fa.gz > decoy_aware_transcripts.fa.gz
#zgrep "^>" human_genome.fa.gz |cut -d " " -f 1 > decoays.txt
#sed -i -e 's/>//g' decoys.txt


##non decoy-aware index and annotation generation
##set up salmon reference transcriptome by downloading the human genome and indexing it
#mkdir salmon_ref
#cd ./salmon_ref
#curl https://ftp.ensembl.org/pub/release-112/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz -o human.fa.gz
#salmon index -t human.fa.gz -i human_index
#curl https://ftp.ensembl.org/pub/release-112/gtf/homo_sapiens/Homo_sapiens.GRCh38.112.gtf.gz -o human.gtf
