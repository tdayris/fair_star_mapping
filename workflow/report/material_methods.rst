Matierial and methods
=====================

Genome information was download from Ensembl. Samtools_ [#samtoolspaper]_ 
and Picard_ [#picardpaper]_ were used to index genome sequences.
Agat_ [#agatpaper]_ was used to correct common issues found in Ensembl
genome annotation files.

Raw fastq file quality was assessed with FastQC_ [#fastqcpaper]_.
Raw fastq files were trimmed using Fastp_ [#fastppaper]_ . Cleaned reads were aligned 
over indexed Ensembl genome with STAR_ [#starpaper]_. Sambamba_ [#sambambapaper]_ 
was used to sort, filter, mark duplicates, and compress aligned reads. Quality 
controls were done on cleaned, sorted, deduplicated aligned reads using 
Picard_ [#picardpaper]_ and Samtools_ [#samtoolspaper]_. 
Additonal quality assessments are done with RSeQC_ [#rseqcpaper]_,
NGSderive_ [#ngsderivepaper]_, GOleft_ [#goleftpaper]_, and RNASeqQC_ [#rnaseqcpaper]_
Quality repord produced during both trimming and mapping steps have been 
aggregated with MultiQC_ [#multiqcpaper]_. The whole pipeline was powered 
by Snakemake_ [#snakemakepaper]_.

This pipeline is freely available on Github_, details about installation
usage, and resutls can be found on the `Snakemake workflow`_ page.

.. [#samtoolspaper] Li, Heng, et al. "The sequence alignment/map format and SAMtools." bioinformatics 25.16 (2009): 2078-2079.
.. [#picardpaper] McKenna, Aaron, et al. "The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data." Genome research 20.9 (2010): 1297-1303.
.. [#agatpaper] Dainat J. AGAT: Another Gff Analysis Toolkit to handle annotations in any GTF/GFF format.  (Version v0.7.0). Zenodo. https://www.doi.org/10.5281/zenodo.3552717
.. [#fastqcpaper] Andrews, S. Fastqc. "A quality control tool for high throughput sequence data. Augen, J.(2004). Bioinformatics in the post-genomic era: Genome, transcriptome, proteome, and information-based medicine." (2010).
.. [#fastppaper] Chen, Shifu, et al. "fastp: an ultra-fast all-in-one FASTQ preprocessor." Bioinformatics 34.17 (2018): i884-i890.
.. [#star2paper] Dobin, Alexander, et al. "STAR: ultrafast universal RNA-seq aligner." Bioinformatics 29.1 (2013): 15-21.
.. [#sambambapaper] Tarasov, Artem, et al. "Sambamba: fast processing of NGS alignment formats." Bioinformatics 31.12 (2015): 2032-2034.
.. [#rseqcpaper] Wang, Liguo, Shengqin Wang, and Wei Li. "RSeQC: quality control of RNA-seq experiments." Bioinformatics 28.16 (2012): 2184-2185.
.. [#ngsderivepaper] McLeod, Clay, et al. "St. Jude Cloud: a pediatric cancer genomic data-sharing ecosystem." Cancer discovery 11.5 (2021): 1082-1099.
.. [#goleftpaper] Pedersen, Brent S., et al. "Indexcov: fast coverage quality control for whole-genome sequencing." Gigascience 6.11 (2017): gix090.
.. [#rnaseqcpaper] Graubert, Aaron, et al. "RNA-SeQC 2: efficient RNA-seq quality control and quantification for large cohorts." Bioinformatics 37.18 (2021): 3048-3050.
.. [#multiqcpaper] Ewels, Philip, et al. "MultiQC: summarize analysis results for multiple tools and samples in a single report." Bioinformatics 32.19 (2016): 3047-3048.
.. [#snakemakepaper] Köster, Johannes, and Sven Rahmann. "Snakemake—a scalable bioinformatics workflow engine." Bioinformatics 28.19 (2012): 2520-2522.

.. _Sambamba: https://snakemake-wrappers.readthedocs.io/en/v3.5.2/wrappers/sambamba.html
.. _STAR: https://snakemake-wrappers.readthedocs.io/en/v3.5.2/wrappers/star.html
.. _Fastp: https://snakemake-wrappers.readthedocs.io/en/v3.5.2/wrappers/fastp.html
.. _Picard: https://snakemake-wrappers.readthedocs.io/en/v3.5.2/wrappers/picard/collectmultiplemetrics.html
.. _MultiQC: https://snakemake-wrappers.readthedocs.io/en/v3.5.2/wrappers/multiqc.html
.. _Snakemake: https://snakemake.readthedocs.io
.. _Github: https://github.com/tdayris/fair_star_mapping
.. _`Snakemake workflow`: https://snakemake.github.io/snakemake-workflow-catalog?usage=tdayris/fair_star_mapping
.. _Agat: https://agat.readthedocs.io/en/latest/index.html
.. _Samtools: https://snakemake-wrappers.readthedocs.io/en/v3.5.2/wrappers/samtools/faidx.html
.. _FastQC: https://snakemake-wrappers.readthedocs.io/en/v3.5.2/wrappers/fastqc.html
.. _GOleft: https://github.com/brentp/goleft
.. _NGSderive: "https://stjudecloud.github.io/ngsderive/"
.. _RSeQC: https://rseqc.sourceforge.net/
.. _RNASeqQC: https://github.com/getzlab/rnaseqc

:Authors:
    Thibault Dayris

:Version: 1.0.0 of 01/11/2024
