## 10x scATACseq test data

Download 10x ATACseq v1 PBMC data for testing

``` sh
wget https://www.10xgenomics.com/resources/datasets/500-peripheral-blood-mononuclear-cells-pbm-cs-from-a-healthy-donor-v-1-0-1.2.0
```

Command used to subset 10x ATACseq v1 fastqs for input into Cellranger

``` sh
for FILE in /Users/alex/dev/data/test_data/10x-ATAC/atac_pbmc_500_v1_fastqs//atac_pbmc_500_v1_S1_L001_*; do gunzip -c $FILE |  head -n 500000 | gzip > /Users/alex/dev/repos/luslab-nf-sc-multi-omic/tests/test_data/10x-ATAC/fastqs/sub_"$(basename "$FILE")"; done
```

## 10x scRNAseq test data

Download 10x RNAseq v2 PBMC data for testing

``` sh
wget https://cf.10xgenomics.com/samples/cell-exp/3.0.0/pbmc_1k_v2/pbmc_1k_v2_fastqs.tar
```

Command used to subset 10x RNAseq v2 fastqs for input into Cellranger 

``` sh
for FILE in /Users/alex/dev/data/test_data/10x-RNA/pbmc_1k_v2_fastqs/pbmc_1k_v2_S1_L001_*; do gunzip -c $FILE |  head -n 500000 | gzip > /Users/alex/dev/repos/luslab-nf-sc-multi-omic/tests/test_data/10x-RNA/fastqs/sub_"$(basename "$FILE")"; done
```

## Ensembl Human GRCh38 fa and GTF test data

Download GTF

``` sh
wget http://ftp.ensembl.org/pub/release-103/gtf/homo_sapiens/Homo_sapiens.GRCh38.103.gtf.gz
```

Command used to subset 10k lines for chr19 from hsap gtf for reference building

``` sh
gunzip -c /Users/alex/dev/genomes/hsap_GRCh38/Homo_sapiens.GRCh38.103.gtf.gz | awk '/^19/' | head -10000 | gzip > /Users/alex/dev/repos/luslab-nf-sc-multi-omic/test_data/genomes/hsap/chr19_10k.gtf.gz
```

Download chr19 sequence

``` sh
wget http://ftp.ensembl.org/pub/release-103/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_rm.chromosome.19.fa.gz
```

Command used to subset first 100k lines from chr19 fa from hsap for reference building

``` sh
gunzip -c /Users/alex/dev/genomes/hsap_GRCh38/Homo_sapiens.GRCh38.dna.chromosome.19.fa.gz | head -100000 | gzip > /Users/alex/dev/repos/luslab-nf-sc-multi-omic/test_data/genomes/hsap/chr19_100k.fa.gz
```



