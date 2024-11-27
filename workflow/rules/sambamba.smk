rule fair_star_mapping_sambamba_sort:
    input:
        branch(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}' & sample_id == '{sample}' & downstream_file == downstream_file",
                within=samples,
            ),
            then="tmp/fair_star_mapping_star_align_pair_ended/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam",
            otherwise="tmp/fair_star_mapping_star_align_single_ended/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam",
        ),
    output:
        temp(
            "tmp/fair_star_mapping_sambamba_sort/{species}.{build}.{release}.{datatype}/{sample}.bam"
        ),
    threads: 6
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000 * 6,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_sambamba_sort/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_sambamba_sort/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_sambamba_sort",
            default="",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/sambamba/sort"


rule fair_star_mapping_sambamba_view:
    input:
        "tmp/fair_star_mapping_sambamba_sort/{species}.{build}.{release}.{datatype}/{sample}.bam",
    output:
        temp(
            "tmp/fair_star_mapping_sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.bam"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000 * 6,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_sambamba_view",
            default="--format 'bam' --filter 'mapping_quality >= 30 and not (unmapped or mate_is_unmapped)' ",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/sambamba/view"


rule fair_star_mapping_sambamba_markdup:
    input:
        "tmp/fair_star_mapping_sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.bam",
    output:
        temp(
            "tmp/fair_star_mapping_sambamba_dedup/{species}.{build}.{release}.{datatype}/{sample}.bam"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000 * 6,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_sambamba_markdup/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_sambamba_markdup/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_sambamba_markdup",
            default="--overflow-list-size=500000",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/sambamba/markdup"
