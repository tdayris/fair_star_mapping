rule fair_star_mapping_ucsc_genepred_to_bed:
    input:
        "reference/annotation/{species}.{build}.{release}.genePred",
    output:
        temp(
            "tmp/fair_star_mapping/ucsc_genepred_to_bed/{species}.{build}.{release}.bed"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 10,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/ucsc_genepred_to_bed/{species}.{build}.{release}.log",
    benchmark:
        "benchmark/fair_star_mapping/ucsc_genepred_to_bed/{species}.{build}.{release}.tsv"
    params:
        extra=dlookup(
            dpath="params/fair_star_mapping/ucsc/genepred2bed",
            within=config,
            default="",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/ucsc/genePredToBed"
