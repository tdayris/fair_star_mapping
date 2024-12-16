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
NGSderive_ [#ngsderivepaper]_, GOleft_ [#goleftpaper]_, RNASeqQC_ [#rnaseqcpaper]_
and Mosdepth_ [#mosdepthpaper]_. Additionalsample quality checks were done with
MTNucRatioCalculator_ [#mtnucratiocalculator]_, and SexDetERRmine_ [#sexdeterrmine]_ 
to verify library and sample expectations.

Quality repord produced during both trimming and mapping steps have been 
aggregated with MultiQC_ [#multiqcpaper]_.

Optional cigar splitting was performed with GATK_ [#gatkpaper]_.

The whole pipeline_ [#fairstarmapping]_ was powered by Snakemake_ [#snakemakepaper]_. 
This pipeline is freely available on Github_, details about 
installation usage, and resutls can be found on the 
`Snakemake workflow`_ page. It relies on `fair-genome-indexer`_ [#fairgenomeindexer]_,
`fair-fastqc-multiqc`_ [#fairfastqcmultiqc]_, and `fair-bowtie2-mapping`_ [#fairbowtiemapping]_ 
pipelines.

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
.. [#mosdepthpaper] Pedersen, Brent S., and Aaron R. Quinlan. "Mosdepth: quick coverage calculation for genomes and exomes." Bioinformatics 34.5 (2018): 867-868.
.. [#mtnucratiocalculator] Alexander Peltzerand Alexander Regueiro. Apeltzer/mtnucratiocalculator: 0.7.1. 0.7.1, Zenodo, 10 Sept. 2024, doi:10.5281/zenodo.13739840.
.. [#sexdeterrmine] Lamnidis, T.C. et al., 2018. Ancient Fennoscandian genomes reveal origin and spread of Siberian ancestry in Europe. Nature communications, 9(1), p.5018. Available at: http://dx.doi.org/10.1038/s41467-018-07483-5.
.. [#multiqcpaper] Ewels, Philip, et al. "MultiQC: summarize analysis results for multiple tools and samples in a single report." Bioinformatics 32.19 (2016): 3047-3048.
.. [#gatkpaper] Van der Auwera, Geraldine A., and Brian D. O'Connor. Genomics in the cloud: using Docker, GATK, and WDL in Terra. O'Reilly Media, 2020.
.. [#pipeline] Dayris, T. (2024). fair-star-mapping (Version 1.2.0) [Computer software]. https://github.com/tdayris/fair_star_mapping
.. [#snakemakepaper] Köster, Johannes, and Sven Rahmann. "Snakemake—a scalable bioinformatics workflow engine." Bioinformatics 28.19 (2012): 2520-2522.
.. [#fairgenomeindexer] Dayris, T. (2024). fair-genome-indexer (Version 3.9.3) [Computer software]. https://github.com/tdayris/fair_genome_indexer
.. [#fairfastqcmultiqc] Dayris, T. (2024). fair-fastqc-multiqc (Version 2.4.2) [Computer software]. https://github.com/tdayris/fair_fastqc_multiqc
.. [#fairbowtiemapping] Dayris, T. (2024). fair-bowtie2-mapping (Version 4.4.0) [Computer software]. https://github.com/tdayris/fair_bowtie2_mapping

.. _Sambamba: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/sambamba.html
.. _STAR: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/star.html
.. _Fastp: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/fastp.html
.. _Picard: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/picard/collectmultiplemetrics.html
.. _MultiQC: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/multiqc.html
.. _Snakemake: https://snakemake.readthedocs.io
.. _Github: https://github.com/tdayris/fair_star_mapping
.. _`Snakemake workflow`: https://snakemake.github.io/snakemake-workflow-catalog?usage=tdayris/fair_star_mapping
.. _Agat: https://agat.readthedocs.io/en/latest/index.html
.. _Samtools: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/samtools/faidx.html
.. _FastQC: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/fastqc.html
.. _GOleft: https://github.com/brentp/goleft
.. _NGSderive: "https://stjudecloud.github.io/ngsderive/"
.. _RSeQC: https://rseqc.sourceforge.net/
.. _RNASeqQC: https://github.com/getzlab/rnaseqc
.. _Mosdepth: https://snakemake-wrappers.readthedocs.io/en/v5.5.0/wrappers/mosdepth.html
.. _SexDetERRmine: ???
.. _MTNucRatioCalculator: ???
.. _`fair-star-mapping`: https://github.com/tdayris/fair_star_mapping
.. _`fair-genome-indexer`: https://github.com/tdayris/fair_genome_indexer
.. _`fair-fastqc-multiqc`: https://github.com/tdayris/fair_fastqc_multiqc
.. _`fair-bowtie2-mapping`: https://github.com/tdayris/fair_bowtie2_mapping

:Authors:
    Thibault Dayris

:Version: 1.0.0 of 01/11/2024
