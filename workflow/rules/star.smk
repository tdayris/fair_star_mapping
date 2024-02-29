rule star_index:
    input:
        fasta="resources/{species}.{build}.{release}.{datatype}.fasta",
        fasta_index="resources/{species}.{build}.{release}.{datatype}.fasta.fai",
        gtf="resources/{species}.{build}.{release}.{datatype}.gtf",
    output:
        directory("{species}.{build}.{release}.{datatype}"),
    threads: 20
    resources:
        # Reserve 45GB + 10GB per attempt
        mem_mb=lambda wildcards, attempt: (1024 * 45) + ((1024 * 10) * attempt),
        # Reserve 45minutes per attempt
        runtime=lambda wildcards, attempt: (60 * 0.75) * attempt,
        tmpdir="tmp",
    benchmark:
        "benchmark/star_index/{species}.{build}.{release}.{datatype}.tsv"
    params:
        extra=config.get("params", {}).get("star", {}).get("index"),
        sjdbOverhang=lambda wildcards: get_sjdb_overhang(wildcards),
    log:
        "logs/star_index/{species}.{build}.{release}.{datatype}.log",
    wrapper:
        "v3.3.6/bio/star/index"


rule star_align:
    input:s
        unpack(get_star_align_input)
    output:
        aln=temp("tmp/star/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam"),
        log=temp("tmp/star/{species}.{build}.{release}.{datatype}/{sample}/Log.out"),
        sj=temp("tmp/star/{species}.{build}.{release}.{datatype}/{sample}/SJ.out.tab"),
    threads: 20
    resources:
        # Reserve 45GB + 10GB per attempt
        mem_mb=lambda wildcards, attempt: (1024 * 45) + ((1024 * 10) * attempt),
        # Reserve 45minutes per attempt
        runtime=lambda wildcards, attempt: (60 * 0.75) * attempt,
        tmpdir="tmp",
    benchmark:
        "benchmark/star_align/{sample}.{species}.{build}.{release}.{datatype}.tsv",
    log:
        "logs/star_align/{sample}.{species}.{build}.{release}.{datatype}.log",
    params:
        extra=config.get("params", {}).get("star", {}).get("align", ""),
    wrapper:
        "v3.3.6/bio/star/align"