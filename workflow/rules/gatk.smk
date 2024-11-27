rule fair_star_mapping_gatk_split_n_cigar_reads:
    input:
        bam="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
        ref=lambda wildcards: select_fasta(wildcards),
    output:
        temp("tmp/fair_star_mapping_gatk_split_n_cigar_reads/{sample}.bam"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000,
        runtime=lambda wildcards, attempt: attempt * 15,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_gatk_split_n_cigar_reads/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_gatk_split_n_cigar_reads/{sample}.tsv"
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_gatk_split_n_cigar_reads",
            default="",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/gatk/splitncigarreads"
