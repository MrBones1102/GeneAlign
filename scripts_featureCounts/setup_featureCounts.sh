#make a conda install folder, download the setup shell script, run the script, remove the script
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh

#create a new environment for RNAseq analysis
canda create --name rnaseq_featureCount

#activate the newly created environment
conda activate rnaseq_featureCount

#add the required channels for packages, as required by bioconda
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

#add the superset of tools (we may only use a subset)
conda install fastqc
conda install multiqc
conda install sortmerna=4.3.6
conda install trimmomatic
conda install hisat2
conda install subread
conda install bioconductor-edger
conda install sra-tools
conda install samtools

#setup SRA-Tool's working directory
mkdir sra_out
cd ./sra_out
vdb-config --prefetch-to-cwd
cd ..

#set up quality control dirs
mkdir qc_files

#set up hisat reference genome and annotations
mkdir hisat_ref
cd ./hisat_ref
wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
tar -xvzf grch38_genome.tar.gz
wget https://ftp.ensembl.org/pub/release-112/gtf/homo_sapiens/Homo_sapiens.GRCh38.112.gtf.gz
gzip -d Homo_sapiens.GRCh38.112.gtf.gz
cd ..

#set up sam dir as hisat2 output and input for bam conversion
mkdir sam_files

#set up bam dir as bam conversion output
mkdir bam_files

#set up sorted bam dir as sorted bam conversion output
mkdir sorted_bam_files

#set up feature counts dir
mkdir gene_counts
