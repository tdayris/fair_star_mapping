Results
=======


Alongside with the report, you may find directories called `reference`,
and `results`.


Results files list
==================


Results
-------

Given a samples called `YYY` and a genome called `XXX`,
the following files are present:


::

    results/
    ├── XXX.dna
    │   ├── Mapping
    │   |   ├── YYY.bam
    │   |   └── YYY.bam.bai
    |   └── QC
    |       ├── MultiQC_Mapping_data.zip
    |       └── MultiQC_Mapping.html
    └── QC
        ├── MultiQC_FastQC_data.zip
        ├── MultiQC_FastQC.html
        ├── report_pe
        │   └── YYY.html
        └── report_se
            └── YYY.html



+---------------+-----------------------------+-----------------------------------------------+
| Directory     | File Extension              | Content                                       |
+===============+=============================+===============================================+
| XXX/Mapping   | `YYY.bam`                   | Aligned reads                                 |
+               +-----------------------------+-----------------------------------------------+
|               | `YYY.bam.bai`               | Aligned reads index                           |
+---------------+-----------------------------+-----------------------------------------------+
| QC            | `MultiQC_FastQC_data.zip`   | Zipped figures and tables                     |
+               +----------------------------+-----------------------------------------------+
|               | `MultiQC_FastQC.html`       | Complete quality report, includes all samples |
+---------------+-----------------------------+-----------------------------------------------+
| QC            | `MultiQC_Mapping_data.zip`  | Zipped figures and tables                     |
+               +---------------------+-----------------------------------------------+
|               | `MultiQC_Mapping.html`      | Complete quality report, includes all samples |
+---------------+-----------------------------+-----------------------------------------------+
| QC/report_pe  | `YYY.html`                  | Sequence quality report for PE sample `YYY`   |
+---------------+-----------------------------+-----------------------------------------------+
| QC/report_se  | `YYY.html`                  | Sequence quality report for SE sample `YYY`   |
+---------------+-----------------------------+-----------------------------------------------+


Reference
---------


Alongside with this report, you may find a directory called `reference`.
You shall find all requested files in it. By default, the following
files are present:

::

    reference/
    ├── blacklist
    |   └── XXX.merged.bed
    ├── variants
    |   ├── XXX.all.vcf.gz
    |   └── XXX.all.vcf.gz.tbi
    ├── sequences
    |   ├── XXX.cdna.fasta
    |   ├── XXX.cdna.fasta.fai
    |   ├── XXX.dna.dict
    |   ├── XXX.dna.fasta
    |   └── XXX.dna.fasta.fai
    └── annotation
        ├── XXX.id_to_gene.tsv
        ├── XXX.t2g.tsv
        └── XXX.gtf


+-------------------+-----------------------------+
| Extension         | Content                     |
+===================+=============================+
| `.bed`            | Genome blacklisted regions  |
+-------------------+-----------------------------+
| `.gtf`            | Genome annotation           |
+-------------------+-----------------------------+
| `.id_to_gene.tsv` | Genome id-to-name           |
+-------------------+-----------------------------+
| `.t2g.tsv`        | Transcript id-to-name       |
+-------------------+-----------------------------+
| `.fasta`          | Genome sequences            |
+-------------------+-----------------------------+
| `.fasta.fai`      | Genome sequences index      |
+-------------------+-----------------------------+
| `.dict`           | Genome sequences dictionary |
+-------------------+-----------------------------+
| `.vcf.gz`         | Genome known variations     |
+-------------------+-----------------------------+

These files are quite volumous and are not embeded in this HTML page. Please
find them directly on file system.
