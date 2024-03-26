rule fair_star_mapping_picard_add_or_replace_groups:
    input:
        "tmp/fair_star_mapping/sambamba/dedup/{species}.{build}.{release}.{datatype}/{sample}.bam",
    output:
        protected("results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 2,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=lambda w: dlookup(
            dpath="params/fair_star_mapping/picard/add_or_replace_groups",
            within=config,
            default=f"--RGLB '{w.species}.{w.build}.{w.release}.{w.sample}' --RGPL ILLUMINA --RGPU '{w.species}.{w.build}.{w.release}.{w.datatype}' --RGSM '{w.sample}' --RGCN 'GustaveRoussy' --RGDS 'Organism_{w.species}.{w.build}.{w.release}.{w.datatype}_Sample_{w.sample}'",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/picard/addorreplacereadgroups"


rule fair_star_mapping_picard_create_multiple_metrics:
    input:
        bam="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
        ref=getattr(
            lookup(
                query="species == '{species}' & build == '{build}' & release == '{release}'",
                within=genomes,
            ),
            "dna_fasta",
            "reference/sequences/{species}.{build}.{release}.{datatype}.fasta",
        ),
    output:
        temp(
            multiext(
                "tmp/fair_star_mapping/picard_create_multiple_metrics/{species}.{build}.{release}.{datatype}/stats/{sample}",
                ".alignment_summary_metrics",
                ".insert_size_metrics",
                ".insert_size_histogram.pdf",
                ".base_distribution_by_cycle_metrics",
                ".base_distribution_by_cycle.pdf",
                ".gc_bias.detail_metrics",
                ".gc_bias.summary_metrics",
                ".gc_bias.pdf",
            )
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: (3 * 1024) * attempt,
        runtime=lambda wildcards, attempt: int(60 * 0.6) * attempt,
        tmpdir="tmp",
    log:
        "logs/fair_star_mapping/picard_create_multiple_metrics/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping/picard_create_multiple_metrics/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=dlookup(
            dpath="params/picard/collectmultiplemetrics", within=config, default=""
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/picard/collectmultiplemetrics"
