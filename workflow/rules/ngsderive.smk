rule fair_bowtie2_mapping_ngsderive_endedness:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp("tmp/fair_bowtie2_mapping/ngsderive/endedness/{species}.{build}.{release}.{datatype}/{sample}.endedness.tsv"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_bowtie2_mapping/ngsderive/endedness/{species}.{build}.{release}.{datatype}/{sample}.endedness.log",
    benchmark:
        "benchmark/fair_bowtie2_mapping/ngsderive/endedness/{species}.{build}.{release}.{datatype}/{sample}.endedness.tsv",
    params:
        command="endedness",
        extra= lookup(dpath="params/fair_bowtie2_mapping/ngsderive/endedness", within=config),
    wrapper:
        "v3.5.0/bio/ngsderive"

rule fair_bowtie2_mapping_ngsderive_strandedness:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp("tmp/fair_bowtie2_mapping/ngsderive/strandedness/{species}.{build}/{release}.{datatype}/{sample}.strandedness.tsv"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_bowtie2_mapping/ngsderive/strandedness/{species}.{build}.{release}.{datatype}/{sample}.strandedness.log",
    benchmark:
        "benchmark/fair_bowtie2_mapping/ngsderive/strandedness/{species}.{build}.{release}.{datatype}/{sample}.strandedness.tsv",
    params:
        command="strandedness",
        extra= lookup(dpath="params/fair_bowtie2_mapping/ngsderive/strandedness", within=config),
    wrapper:
        "v3.5.0/bio/ngsderive"

     
rule fair_bowtie2_mapping_ngsderive_encoding:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp("tmp/fair_bowtie2_mapping/ngsderive/encoding/{species}.{build}/{release}.{datatype}/{sample}.encoding.tsv"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_bowtie2_mapping/ngsderive/encoding/{species}.{build}.{release}.{datatype}/{sample}.encoding.log",
    benchmark:
        "benchmark/fair_bowtie2_mapping/ngsderive/encoding/{species}.{build}.{release}.{datatype}/{sample}.encoding.tsv",
    params:
        command="encoding",
        extra= lookup(dpath="params/fair_bowtie2_mapping/ngsderive/encoding", within=config),
    wrapper:
        "v3.5.0/bio/ngsderive"

     
rule fair_bowtie2_mapping_ngsderive_instrument:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp("tmp/fair_bowtie2_mapping/ngsderive/instrument/{species}.{build}/{release}.{datatype}/{sample}.instrument.tsv"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_bowtie2_mapping/ngsderive/instrument/{species}.{build}.{release}.{datatype}/{sample}.instrument.log",
    benchmark:
        "benchmark/fair_bowtie2_mapping/ngsderive/instrument/{species}.{build}.{release}.{datatype}/{sample}.instrument.tsv",
    params:
        command="instrument",
        extra= lookup(dpath="params/fair_bowtie2_mapping/ngsderive/instrument", within=config),
    wrapper:
        "v3.5.0/bio/ngsderive"

     
rule fair_bowtie2_mapping_ngsderive_readlen:
    input:
        ngs="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam",
        ngs_bai="results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai",
    output:
        temp("tmp/fair_bowtie2_mapping/ngsderive/readlen/{species}.{build}/{release}.{datatype}/{sample}.readlen.tsv"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 25,
        tmpdir=tmp,
    log:
        "logs/fair_bowtie2_mapping/ngsderive/readlen/{species}.{build}.{release}.{datatype}/{sample}.readlen.log",
    benchmark:
        "benchmark/fair_bowtie2_mapping/ngsderive/readlen/{species}.{build}.{release}.{datatype}/{sample}.readlen.tsv",
    params:
        command="readlen",
        extra= lookup(dpath="params/fair_bowtie2_mapping/ngsderive/readlen", within=config),
    wrapper:
        "v3.5.0/bio/ngsderive"

     
