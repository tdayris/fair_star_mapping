rule fair_star_mapping_rnaseqc:
    input:
        gtf=lambda wildcards: get_gtf(wildcards),
        fasta=lambda wildcards: select_fasta(wildcards),
        bam="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        bam_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        metrics=temp(
            "tmp/fair_star_mapping_rnaseqc/{species}.{build}.{release}.{datatype}/{sample}.metrics.tsv"
        ),
        exon_read=temp(
            "tmp/fair_star_mapping_rnaseqc/{species}.{build}.{release}.{datatype}/{sample}.exon_reads.gct"
        ),
        gene_read=temp(
            "tmp/fair_star_mapping_rnaseqc/{species}.{build}.{release}.{datatype}/{sample}.gene_reads.gct"
        ),
        gene_tpm=temp(
            "tmp/fair_star_mapping_rnaseqc/{species}.{build}.{release}.{datatype}/{sample}.gene_tpm.gct"
        ),
        coverage=temp(
            "tmp/fair_star_mapping_rnaseqc/{species}.{build}.{release}.{datatype}/{sample}.coverage.tsv"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_rnaseqc/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_rnaseqc/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_rnaseqc",
            default="",
        ),
        prefix="{sample}",
    conda:
        "../envs/rnaseqc.yaml"
    script:
        "../scripts/fair_star_mapping_rnaseqc.py"
