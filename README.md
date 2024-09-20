# GeneAlign
 bash scripts for setting up a gene alignment pipeline

### Prologue
- Invoke `nproc` to determine the number of processors you can devote to these operations. They will ask for "threads" when running and you can use up to your `nproc`.

## __Installing__
1. git clone this repository and place setup_salmon.sh and run_salmon.sh into desired working directory
2. In terminal, run `bash -i setup_salmon.sh` to begin the install process.
 - If installing conda through `setup_salmon.sh` you may need to run with `bash` wihtout `-i`
 - Additionally, conda may fail to initialize properly. In this case, manually install conda on your system prior to continuing.
3. With conda installed fully, invoke `bash -i setup_salmon.sh` again to setup the salmon working directories.
 - This will include making a decoy-aware salmon index which can be very RAM intensive and may fail unless enough RAM is available.
4. When finished, you should find `./salmon_processing` working dir populated by `/sra_out` and `salmon_ref`.
 - `salmon_ref` should be fully populated with `decoys.txt`, `human_genome.fa.gz`, `human_transcriptome.fa.gz`, `human_gentrome.fa.gz`, `mappings.gtf`, and `\salmon_index`.
 - `\salmon_index` should be populated by `info.json` and `versionInfo.json` (and many other files) if building the index worked.

## __Running__
1. Source an accession list of samples you wish to analyze and take note of whether the data is paired or single ended.
2. Download or generate a list of the accession numbers for the samples, line-by-line, in an `accession_list.txt` file.
3. Place your `accession_list.txt` in the `/sra_out` folder.
4. Invoke `bash -i run_salmon.sh` and follow the prompts.
5. To be continued...