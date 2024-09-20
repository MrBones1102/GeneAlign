# GeneAlign
 bash scripts for setting up a gene alignment pipeline

### Prologue
- Invoke `nproc` to determine the number of processors you can devote to these operations. They will ask for "threads" when running and you can use up to your `nproc`.

## __Installing__
1. git clone this repository and place setup_salmon.sh and run_salmon.sh into desired working directory
2. In terminal, run `bash -i setup_salmon.sh` to begin the install process.
  - If installing conda through `setup_salmon.sh` you may need to invoke `bash` wihtout `-i`
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

### __Resources__
- Miniconda
 - _Anaconda Software Distribution_ Computer software. Vers. 24.7.1. Anaconda, Sept. 2024. Web. <https://anaconda.com>
- SRA-Toolkit
 - sra-tools Vers. 3.1.0. NCBI, Sept. 2024. Web. <https://github.com/ncbi/sra-tools>
- Salmon
 - Patro, R., Duggal, G., Love, M. I., Irizarry, R. A., & Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. Nature Methods. <https://github.com/COMBINE-lab/salmon>
- Ensembl database (human genome, human transcriptome, human gene mappings)
 - Peter W Harrison, M Ridwan Amode, Olanrewaju Austine-Orimoloye, Andrey G Azov, Matthieu Barba, If Barnes, Arne Becker, Ruth Bennett, Andrew Berry, Jyothish Bhai, Simarpreet Kaur Bhurji, Sanjay Boddu, Paulo R Branco Lins, Lucy Brooks, Shashank Budhanuru Ramaraju, Lahcen I Campbell, Manuel Carbajo Martinez, Mehrnaz Charkhchi, Kapeel Chougule, Alexander Cockburn, Claire Davidson, Nishadi H De Silva, Kamalkumar Dodiya, Sarah Donaldson, Bilal El Houdaigui, Tamara El Naboulsi, Reham Fatima, Carlos Garcia Giron, Thiago Genez, Dionysios Grigoriadis, Gurpreet S Ghattaoraya, Jose Gonzalez Martinez, Tatiana A Gurbich, Matthew Hardy, Zoe Hollis, Thibaut Hourlier, Toby Hunt, Mike Kay, Vinay Kaykala, Tuan Le, Diana Lemos, Disha Lodha, Diego Marques-Coelho, Gareth Maslen, Gabriela Alejandra Merino, Louisse Paola Mirabueno, Aleena Mushtaq, Syed Nakib Hossain, Denye N Ogeh, Manoj Pandian Sakthivel, Anne Parker, Malcolm Perry, Ivana Piližota, Daniel Poppleton, Irina Prosovetskaia, Shriya Raj, José G Pérez-Silva, Ahamed Imran Abdul Salam, Shradha Saraf, Nuno Saraiva-Agostinho, Dan Sheppard, Swati Sinha, Botond Sipos, Vasily Sitnik, William Stark, Emily Steed, Marie-Marthe Suner, Likhitha Surapaneni, Kyösti Sutinen, Francesca Floriana Tricomi, David Urbina-Gómez, Andres Veidenberg, Thomas A Walsh, Doreen Ware, Elizabeth Wass, Natalie L Willhoft, Jamie Allen, Jorge Alvarez-Jarreta, Marc Chakiachvili, Bethany Flint, Stefano Giorgetti, Leanne Haggerty, Garth R Ilsley, Jon Keatley, Jane E Loveland, Benjamin Moore, Jonathan M Mudge, Guy Naamati, John Tate, Stephen J Trevanion, Andrea Winterbottom, Adam Frankish, Sarah E Hunt, Fiona Cunningham, Sarah Dyer, Robert D Finn, Fergal J Martin, and Andrew D Yates. Ensembl 2024. Nucleic Acids Res. 2024, 52(D1):D891–D899. PMID: 37953337. 10.1093/nar/gkad1049.
