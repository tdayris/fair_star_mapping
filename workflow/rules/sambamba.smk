rule fair_star_mapping_sambamba_sort:
    input:
        branch(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}' & sample_id == '{sample}' & downstream_file == downstream_file",
                within=genomes
            ),
            then="tmp/fair_star_mapping/star_paired/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam",
            otherwise="tmp/fair_star_mapping/star_single/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam",
        )
    output:
        temp("tmp/fair_star_mapping/sambamba/{species}.{build}.{release}.{datatype}/{sample}.bam"),
    threads: 6
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 6,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/sambamba_sort/{species}.{build}.{release}.{datatype}/{sample}.log"
    benchmark:
        "benchmark/fair_star_mapping/sambamba_sort/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra= lookup(dpath="params/fair_star_mapping/sambamba/sort", within=config),
    wrapper:
        "v3.5.0/bio/sambamba/sort"

rule fair_star_mapping_sambamba_view:
    input:
        "tmp/fair_star_mapping/sambamba_sort/{species}.{build}.{release}.{datatype}/{sample}.bam",
    output:
        temp("tmp/fair_star_mapping/sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.bam"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 6,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.log"
    benchmark:
        "benchmark/fair_star_mapping/sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra= lookup(dpath="params/fair_star_mapping/sambamba/view", within=config),
    wrapper:
        "v3.5.0/bio/sambamba/view"


rule fair_star_mapping_sambamba_markdup:
    input:
        "tmp/fair_star_mapping/sambamba_view/{species}.{build}.{release}.{datatype}/{sample}.bam",
    output:
        protected("results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 6,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/sambamba_markdup/{species}.{build}.{release}.{datatype}/{sample}.log"
    benchmark:
        "benchmark/fair_star_mapping/sambamba_markdup/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra= lookup(dpath="params/fair_star_mapping/sambamba/markdup", within=config),
    wrapper:
        "v3.5.0/bio/sambamba/markdup"
    

rule fair_star_mapping_sambamba_index:
    input:
        "results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam"
    output:
        protected("results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 2,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/sambamba_index/{species}.{build}.{release}.{datatype}/{sample}.log"
    benchmark:
        "benchmark/fair_star_mapping/sambamba_index/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    wrapper:
        "v3.5.0/bio/sambamba/index"
