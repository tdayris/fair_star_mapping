rule fair_star_mapping_ngsderive_endedness:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        tsv=temp(
            "tmp/fair_star_mapping/ngsderive/endedness/{species}.{build}.{release}.{datatype}/{sample}.endedness.tsv"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/ngsderive/endedness/{species}.{build}.{release}.{datatype}/{sample}.endedness.log",
    benchmark:
        "benchmark/fair_star_mapping/ngsderive/endedness/{species}.{build}.{release}.{datatype}/{sample}.endedness.tsv"
    params:
        command="endedness",
        extra=dlookup(
            dpath="params/fair_star_mapping/ngsderive/endedness",
            within=config,
            default="",
        ),
    conda:
        "../envs/ngsderive.yaml"
    script:
        "../scripts/ngsderive.py"


rule fair_star_mapping_ngsderive_strandedness:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        tsv=temp(
            "tmp/fair_star_mapping/ngsderive/strandedness/{species}.{build}.{release}.{datatype}/{sample}.strandedness.tsv"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/ngsderive/strandedness/{species}.{build}.{release}.{datatype}/{sample}.strandedness.log",
    benchmark:
        "benchmark/fair_star_mapping/ngsderive/strandedness/{species}.{build}.{release}.{datatype}/{sample}.strandedness.tsv"
    params:
        command="strandedness",
        extra=dlookup(
            dpath="params/fair_star_mapping/ngsderive/strandedness",
            within=config,
            default="",
        ),
    conda:
        "../envs/ngsderive.yaml"
    script:
        "../scripts/ngsderive.py"


rule fair_star_mapping_ngsderive_encoding:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        tsv=temp(
            "tmp/fair_star_mapping/ngsderive/encoding/{species}.{build}.{release}.{datatype}/{sample}.encoding.tsv"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/ngsderive/encoding/{species}.{build}.{release}.{datatype}/{sample}.encoding.log",
    benchmark:
        "benchmark/fair_star_mapping/ngsderive/encoding/{species}.{build}.{release}.{datatype}/{sample}.encoding.tsv"
    params:
        command="encoding",
        extra=dlookup(
            dpath="params/fair_star_mapping/ngsderive/encoding",
            within=config,
            default="",
        ),
    conda:
        "../envs/ngsderive.yaml"
    script:
        "../scripts/ngsderive.py"


rule fair_star_mapping_ngsderive_instrument:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        tsv=temp(
            "tmp/fair_star_mapping/ngsderive/instrument/{species}.{build}.{release}.{datatype}/{sample}.instrument.tsv"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/ngsderive/instrument/{species}.{build}.{release}.{datatype}/{sample}.instrument.log",
    benchmark:
        "benchmark/fair_star_mapping/ngsderive/instrument/{species}.{build}.{release}.{datatype}/{sample}.instrument.tsv"
    params:
        command="instrument",
        extra=dlookup(
            dpath="params/fair_star_mapping/ngsderive/instrument",
            within=config,
            default="",
        ),
    conda:
        "../envs/ngsderive.yaml"
    script:
        "../scripts/ngsderive.py"


rule fair_star_mapping_ngsderive_readlen:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        tsv=temp(
            "tmp/fair_star_mapping/ngsderive/readlen/{species}.{build}.{release}.{datatype}/{sample}.readlen.tsv"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/ngsderive/readlen/{species}.{build}.{release}.{datatype}/{sample}.readlen.log",
    benchmark:
        "benchmark/fair_star_mapping/ngsderive/readlen/{species}.{build}.{release}.{datatype}/{sample}.readlen.tsv"
    params:
        command="readlen",
        extra=dlookup(
            dpath="params/fair_star_mapping/ngsderive/readlen",
            within=config,
            default="",
        ),
    conda:
        "../envs/ngsderive.yaml"
    script:
        "../scripts/ngsderive.py"
