module fair_fastqc_multiqc:
    snakefile:
        github("tdayris/fair_fastqc_multiqc", path="workflow/Snakefile", branch="master")#tag="2.2.2")
    config:
        config


use rule * from fair_fastqc_multiqc
