rule fair_star_mapping_picard_add_or_replace_groups:
    input:
        "tmp/fair_star_mapping_sambamba_dedup/{species}.{build}.{release}.{datatype}/{sample}.bam",
    output:
        protected("results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000 * 2,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_picard_add_or_replace_groups/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_picard_add_or_replace_groups/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=lambda w: lookup_config(
            dpath="params/fair_star_mapping_picard_add_or_replace_groups",
            default=f"--RGLB '{w.species}.{w.build}.{w.release}.{w.sample}' --RGPL ILLUMINA --RGPU '{w.species}.{w.build}.{w.release}.{w.datatype}' --RGSM '{w.sample}' --RGCN 'GustaveRoussy' --RGDS 'Organism_{w.species}.{w.build}.{w.release}.{w.datatype}_Sample_{w.sample}'",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/picard/addorreplacereadgroups"
