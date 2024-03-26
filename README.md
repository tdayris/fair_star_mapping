[![Snakemake](https://img.shields.io/badge/snakemake-≥7.29.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/tdayris/fair_genome_indexer/workflows/Tests/badge.svg?branch=main)](https://github.com/tdayris/fair_genome_indexer/actions?query=branch%3Amain+workflow%3ATests)

Snakemake workflow used to align ungapped reads to the genome with Bowtie2.

## Usage

The usage of this workflow is described in the [Snakemake workflow catalog](https://snakemake.github.io/snakemake-workflow-catalog?usage=tdayris/fair_bowtie2_mapping) it is also available [locally](https://github.com/tdayris/fair_bowtie2_mapping/blob/main/workflow/report/usage.rst) on a single page.
 
## Results

A complete description of the results can be found here in [workflow reports](https://github.com/tdayris/fair_bowtie2_mapping/blob/main/workflow/report/results.rst).

## Material and Methods

The tools used in this pipeline are described [here](https://github.com/tdayris/fair_bowtie2_mapping/blob/main/workflow/report/material_methods.rst) textually. Web-links are available below:


### Index and genome sequences with [`fair_genome_indexer`](https://github.com/tdayris/fair_genome_indexer/)

See [`fair_genome_indexer`](https://github.com/tdayris/fair_genome_indexer/) documentation about DNA sequence preparation

### Raw-sequences QC with [`fair_fastqc_multiqc`](https://github.com/tdayris/fair_fastqc_multiqc/)

See  [`fair_fastqc_multiqc`](https://github.com/tdayris/fair_fastqc_multiqc/) documentation about ranw sequences quality controls

### STAR Mapping

| Step          | Wrapper                                                                                                  |
| ------------- | -------------------------------------------------------------------------------------------------------- |
| STAR-index    | [star-index-wrapper](https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/star/index.html)       |
| STAR-align    | [star-align-wrapper](https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/star/align.html)       |
| Sambamba-sort | [sambamba-sort-wrapper](https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/sambamba/sort.html) |

```
┌───────────────────────────┐   ┌─────────────────────────┐
│Genome indexation (STAR)   │   │Sequence cleaning (fastp)│
└──────────────┬────────────┘   └────────┬────────────────┘
               │                         │                 
               │                         │                 
┌──────────────▼───────────────┐         │                 
│Short read alignment (STAR)   ◄─────────┘                 
└──────────────┬───────────────┘                           
               │                                           
               │                                           
┌──────────────▼───────────────────────────┐               
│Sort and compress aligned reads (sambamba)│               
└──────────────────────────────────────────┘               
```


### Filtering

| Step             | Wrapper                                                                                                |
| ---------------- | ------------------------------------------------------------------------------------------------------ |
| Sambamba-view    | [sambamba-view](https://snakemake-wrappers.readthedocs.io/en/v3.4.1/wrappers/sambamba/view.html)       |
| Sambamba-markdup | [sambamba-markdup](https://snakemake-wrappers.readthedocs.io/en/v3.4.1/wrappers/sambamba/markdup.html) |
| Sambamba-index   | [sambamba-index](https://snakemake-wrappers.readthedocs.io/en/v3.4.1/wrappers/sambamba/index.html)     |

```
┌──────────────────────────┐        
│Aligned reads (see above) │        
└──────────────┬───────────┘        
               │                    
               │                    
┌──────────────▼──────────────┐     
│Filter low quality (sambamba)│     
└──────────────┬──────────────┘     
               │                    
               │                    
┌──────────────▼───────────┐        
│Mark duplicates (sambamba)│        
└──────────────┬───────────┘        
               │                    
               │                    
┌──────────────▼───────────┐        
│Add read groups (picard)  │        
└──────────────┬───────────┘        
               │                    
               │                    
               │                    
┌──────────────▼───────────────────┐
│Index aligned sequences (sambamba)│
└──────────────────────────────────┘
```

### QC

| Step     | Wrapper                                                                                                                          |
| -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Picard   | [picard-collectmultiplemetrics](https://snakemake-wrappers.readthedocs.io/en/v3.4.1/wrappers/picard/collectmultiplemetrics.html) |
| Samtools | [samtools-stats](https://snakemake-wrappers.readthedocs.io/en/v3.4.1/wrappers/samtools/stats.html)                               |
| MultiQC  | [multiqc-wrapper](https://snakemake-wrappers.readthedocs.io/en/v3.4.1/wrappers/multiqc.html)                                     |

```
┌──────────────────────┐        ┌─────────────────────┐                ┌─────────────────────────┐
│ Cleaned reads (fastp)│    ┌───┤Duplicates (sambamba)◄────────────────┤Aligned reads (see above)│
└─────────────────────┬┘    │   └─────────────────────┘                └────┬────────────────────┘
                      │     │                                               │                     
                      ├─────┘                                               │                     
                      │         ┌──────────────────────────┐                │                     
                      ├─────────┤Alignment metrics (picard)◄────────────────┤                     
                      │         └──────────────────────────┘                │                     
                      │                                                     │                     
                      │                                                     │                     
                      │         ┌────────────────────────────┐              │                     
                      ├─────────┤Alignment metrics (samtools)◄──────────────┤                     
                      │         └────────────────────────────┘              │                     
                      │                                                     │                     
┌────────────────┐    │                                                     │                     
│ Quality report │    │         ┌─────────────────────────┐                 │                     
│   (multiqc)    ◄────┼─────────┤Alignment metrics (rseqc)◄─────────────────┤                     
└────────────────┘    │         └─────────────────────────┘                 │                     
                      │                                                     │                     
                      │                                                     │                     
                      │         ┌───────────────────────────┐               │                     
                      ├─────────┤Library metrics (ngsderive)◄───────────────┤                     
                      │         └───────────────────────────┘               │                     
                      │                                                     │                     
                      │                                                     │                     
                      │         ┌─────────────────────────┐                 │                     
                      ├─────────┤Coverage metrics (goleft)◄─────────────────┤                   
                      │         └─────────────────────────┘                 │                      
                      │                                                     │                     
                      │         ┌───────────────────────────┐               │                     
                      └─────────┤Alignment metrics (rnaseqc)◄───────────────┘                     
                                └───────────────────────────┘                                      
```
