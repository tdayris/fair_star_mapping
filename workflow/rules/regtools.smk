rule fair_star_mapping_regtools_extract_junctions:
    input:
        bam="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp(
            "tmp/fair_star_mapping_regtools_extract_junctions/{species}.{build}.{release}.{datatype}/{sample}.bed"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000,
        runtime=lambda wildcards, attempt: attempt * 15,
        tmpdir=tmp,
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_regtools_extract_junctions",
            default=" -s XS ",
        ),
    log:
        "logs/fair_star_mapping_regtools_extract_junctions/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_regtools_extract_junctions/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    conda:
        "../envs/regtools.yaml"
    shell:
        "regtools junctions extract "
        "{params.extra} {input.bam} "
        "-o {output} > {log} 2>&1"


rule fair_star_mapping_regtools_junctions_annotate:
    input:
        junctions="tmp/fair_star_mapping_regtools_extract_junctions/{species}.{build}.{release}.{datatype}/{sample}.bed",
        reference=lambda wildcards: select_fasta(wildcards),
        annotation=lambda wildcards: get_gtf(wildcards),
    output:
        report(
            "results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.regtools_junctions_annotated.bed",
            caption="../report/regtools.rst",
            category="Splicing",
            labels={
                "regions": "bed",
                "sample": "{sample}",
            },
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1_000,
        runtime=lambda wildcards, attempt: attempt * 15,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_regtools_junctions_annotate/{species}.{build}.{release}.{datatype}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_regtools_junctions_annotate/{species}.{build}.{release}.{datatype}/{sample}.tsv"
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_regtools_junctions_annotate",
            default="",
        ),
    conda:
        "../envs/regtools.yaml"
    shell:
        "regtools junctions annotate "
        "{params.extra} {input.junctions} "
        "{input.reference} {input.annotation} "
        "-o {output} > {log} 2>&1 "
