This pipeline requires two configuration file:

# `config.yaml`

A standard `Snakemake` configuration, yaml-formatted file containing a list of
all parameters accepted in this workflow:

* `samples`: Path to the file containing link between samples and their fastq file(s)
* `params`: Per-tool list of optional parameters

Example:

```
samples: config/samples.csv

# Optional parameters
params:
  star:
    # Optional parameters for star index
    index: ""
    # Optional parameters for star align
    align: ""
  sambamba:
    # Optional parameters for sambamba view
    view: "--format 'bam' --filter 'mapping_quality >= 30 and not (unmapped or mate_is_unmapped)' "
    # Optional parameters for sambamba markdup
    markdup: "--remove-duplicates"
  picard:
    # Mapping QC optional parameters
    metrics: ""
```

# `samples.csv`

A CSV-formatted text file containing the following mandatory columns:

* `sample_id`: Unique name of the sample
* `upstream_file`: Path to upstream fastq file
* `species`: The species name, according to Ensembl standards
* `build`: The corresponding genome build, according to Ensembl standards
* `release`: The corresponding genome release, according to Ensembl standards
* `downstream_file`: Optional path to downstream fastq file

Example:

```
sample_id,upstream_file,downstream_file,species,build,release
sac_a,data/reads/a.scerevisiae.1.fq,data/reads/a.scerevisiae.2.fq,saccharomyces_cerevisiae,R64-1-1,110
```

While `CSV` format is tested and recommended, this workflow uses python
`csv.Sniffer()` to detect column separator. Tabulation and semicolumn are
also accepted as field separator. Remember that only comma-separator is
tested.

# `genomes.csv`

This file is fully optional. When missing, the genome sequences
will be downloaded from Ensembl and indexed.

A CSV-formatted text file containing the following mandatory columns:

* `species`: The species name, according to Ensembl standards
* `build`: The corresponding genome build, according to Ensembl standards
* `release`: The corresponding genome release, according to Ensembl standards

The following columns are optional and are used to avoid downloading genomes:

* `fasta`: Path to the reference genome sequence (FASTA formatted)
* `fasta_index`: Path to the reference genome sequence index (FAI formatted)
* `bowtie2_index`: Path to the main directory containing reference index

Example:

```
species,build,release,fasta,fasta_index,bowtie2_index
homo_sapiens,GRCh38,110,/path/to/sequence.fasta,/path/to/sequence.fasta.fai,/path/to/bowtie2_sequence/
mus_musculus,GRCm38,99,,,
mus_musculus,GRCm39,110,,,
```

While `CSV` format is tested and recommended, this workflow uses python
`csv.Sniffer()` to detect column separator. Tabulation and semicolumn are
also accepted as field separator. Remember that only comma-separator is
tested.