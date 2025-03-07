rule fair_star_mapping_preseq_lc_extrap_bam:
    input:
        "results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        "results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp(
            "tmp/fair_star_mapping_preseq_lc_extrap_bam/{species}.{build}.{release}.{datatype}/{sample}.lc_extrap"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000,
        runtime=lambda wildcards, attempt: attempt * 15,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_preseq_lc_extrap_bam/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_preseq_lc_extrap_bam/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        lookup_config(
            dpath="params/fair_star_mapping_preseq_lc_extrap_bam",
            default="",
        ),
    wrapper:
        "v5.8.3/bio/preseq/lc_extrap"
