rule fair_star_mapping_star_index:
    input:
        fasta=getattr(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=genomes
            ),
            "dna_fasta",
            "resources/{species}.{build}.{release}.{datatype}.fasta",
        ),
        fasta_index=getattr(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=genomes
            ),
            "dna_fai",
            "resources/{species}.{build}.{release}.{datatype}.fasta.fai",
        ),
        gtf=getattr(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=genomes
            ),
            "gtf",
            "resources/{species}.{build}.{release}.{datatype}.gtf",
        ),
    output:
        directory("reference/star_index/{species}.{build}.{release}.{datatype}"),
    threads: 20
    resources:
        mem_mb=lambda wildcards, attempt: (1024 * 45) + ((1024 * 10) * attempt),
        runtime=lambda wildcards, attempt: (60 * 0.75) * attempt,
        tmpdir="tmp",
    benchmark:
        "benchmark/star_index/{species}.{build}.{release}.{datatype}.tsv"
    params:
        extra= lookup(dpath="params/fair_star_mapping/star/index", within=config)
        sjdbOverhang=lambda wildcards: get_sjdb_overhang(wildcards),
    log:
        "logs/star_index/{species}.{build}.{release}.{datatype}.log",
    wrapper:
        "v3.5.0/bio/star/index"


rule fair_star_mapping_star_align_pair_ended:
    input:
        fq1="tmp/fair_star_mapping/fastp_trimmin_pair_ended/{sample}.1.fastq",
        fq2="tmp/fair_star_mapping/fastp_trimmin_pair_ended/{sample}.2.fastq",
        idx="reference/star_index/{species}.{build}.{release}.{datatype}",        
    output:
        aln=temp(
            "tmp/star/{species}.{build}.{release}.{datatype}/{sample}_paired/{sample}.bam"
        ),
        log=temp("tmp/star/{species}.{build}.{release}.{datatype}/{sample}_paired/Log.out"),
        sj=temp("tmp/star/{species}.{build}.{release}.{datatype}/{sample}_paired/SJ.out.tab"),
    threads: 20
    resources:
        mem_mb=lambda wildcards, attempt: (1024 * 45) + ((1024 * 10) * attempt),
        runtime=lambda wildcards, attempt: (60 * 0.75) * attempt,
        tmpdir="tmp",
    benchmark:
        "benchmark/star_align/{sample}_paired.{species}.{build}.{release}.{datatype}.tsv"
    log:
        "logs/star_align/{sample}_paired.{species}.{build}.{release}.{datatype}.log",
    params:
        extra= lookup(dpath="params/fair_star_mapping/star/align", within=config),
    wrapper:
        "v3.5.0/bio/star/align"

use rule fair_star_mapping_star_align_pair_ended as fair_star_mapping_star_align_single_ended with:
    input:
        fq1="tmp/fair_star_mapping/fastp_trimmin_single_ended/{sample}.fastq",
    output:
        aln=temp(
            "tmp/star/{species}.{build}.{release}.{datatype}/{sample}_single/{sample}.bam"
        ),
        log=temp("tmp/star/{species}.{build}.{release}.{datatype}/{sample}_single/Log.out"),
        sj=temp("tmp/star/{species}.{build}.{release}.{datatype}/{sample}_single/SJ.out.tab"),  
    log:
        "logs/fair_star_mapping/star_align/{sample}_single.{species}.{build}.{release}.{datatype}.log",
    benchmark:
        "benchmark/fair_star_mapping/star_align/{sample}_single.{species}.{build}.{release}.{datatype}.tsv",
    params:
        extra= lookup(dpath="params/fair_star_mapping/star/align", within=config)
