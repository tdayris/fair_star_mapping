rule fair_star_mapping_samtools_stats:
    input:
        bam="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp(
            "tmp/fair_star_mapping/samtools_stats/{species}.{build}.{release}.{datatype}/{sample}.txt"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: (2 * 1024) * attempt,
        runtime=lambda wildcards, attempt: int(60 * 0.6) * attempt,
        tmpdir="tmp",
    log:
        "logs/fair_star_mapping/samtools_stats/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping/samtools_stats/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=dlookup(dpath="params/samtools/stats", within=config, default=""),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/samtools/stats"
