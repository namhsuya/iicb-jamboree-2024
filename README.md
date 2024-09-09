# Assignment for CSIR-IICB Jamboree 2024 Interview
Bash script to download SRA data from NCBI

## Getting Started 

The following steps needs to be followed for the script to work

### Prerequisites

The following softwares/tools must be available from the base path for the script to function as expected.
1. [Miniconda3](https://docs.anaconda.com/miniconda/miniconda-other-installer-links/)
2. [SRA-Toolkit](https://github.com/ncbi/sra-tools)
3. [Entrez Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/)

### Installation and Setup
 
  ```
  ## Setup miniconda
  mkdir -p ~/miniconda3
  wget https://repo.anaconda.com/miniconda/Miniconda3-py312_24.7.1-0-Windows-x86_64.exe -O ~/miniconda3/miniconda.sh
  bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
  rm ~/miniconda3/miniconda.sh
  ~/miniconda3/bin/conda init bash

  ## Create environment, install required tools
  conda create -n jamboree -c conda-forge -c bioconda sra-tools entrez-direct=22.4 -y
  conda activate jamboree

  ## Clone repository, make `jamboree.sh` executable
  git clone https://github.com/namhsuya/iicb-jamboree-2024.git
  cd iicb-jamboree-2024
  chmod +x jamboree.sh
  ```

### Usage

The script accepts a single query, if associated SRA Run IDs are found for the query they are downloaded in a folder with the same name as the query. Otherwise it exits.

`Usage: ./jamboree.sh <query>`

### Test cases

Following test cases can be used to test the script:

1. Genome Assembly Accession ID: GCA_000013265.1
   ```
   ./jamboree.sh GCA_000013265.1
   ```
This will fetch 6 SRA files associated with this genome assembly

2. BioSample ID: SAMN00000110
   ```
   ./jamboree.sh SAMN00000110
   ```
This will fetch 6 SRA files associated with this BioSample ID

3. Nucleotide ID: NC_002549.1
      ```
   ./jamboree.sh SAMN00000110
   ```
This will not fetch any file as no SRA files are associated directly with this nucleotide sequence or the bioproject
