rule fair_star_mapping_star_index:
    input:
        fasta=getattr(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=genomes,
            ),
            "dna_fasta",
            "reference/sequences/{species}.{build}.{release}.{datatype}.fasta",
        ),
        fasta_index=getattr(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=genomes,
            ),
            "dna_fai",
            "reference/sequences/{species}.{build}.{release}.{datatype}.fasta.fai",
        ),
        gtf=getattr(
            lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=genomes,
            ),
            "gtf",
            "reference/annotation/{species}.{build}.{release}.gtf",
        ),
    output:
        directory("reference/star_index/{species}.{build}.{release}.{datatype}"),
    threads: 20
    resources:
        mem_mb=lambda wildcards, attempt: (1024 * 45) + ((1024 * 10) * attempt),
        runtime=lambda wildcards, attempt: (60 * 0.75) * attempt,
        tmpdir=tmp,
    benchmark:
        "benchmark/star_index/{species}.{build}.{release}.{datatype}.tsv"
    params:
        extra=dlookup(
            dpath="params/fair_star_mapping/star/index", within=config, default=""
        ),
        sjdbOverhang=lambda wildcards: get_sjdb_overhang(wildcards),
    log:
        "logs/star_index/{species}.{build}.{release}.{datatype}.log",
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/star/index"


rule fair_star_mapping_star_align_pair_ended:
    input:
        fq1="tmp/fair_star_mapping/fastp_trimming_pair_ended/{sample}.1.fastq",
        fq2="tmp/fair_star_mapping/fastp_trimming_pair_ended/{sample}.2.fastq",
        idx="reference/star_index/{species}.{build}.{release}.{datatype}",
    output:
        aln=temp(
            "tmp/fair_star_mapping/star_paired/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam"
        ),
        log=temp(
            "tmp/fair_star_mapping/star_paired/{species}.{build}.{release}.{datatype}/{sample}/Log.out"
        ),
        sj=temp(
            "tmp/fair_star_mapping/star_paired/{species}.{build}.{release}.{datatype}/{sample}/SJ.out.tab"
        ),
    threads: 20
    resources:
        mem_mb=lambda wildcards, attempt: (1024 * 45) + ((1024 * 10) * attempt),
        runtime=lambda wildcards, attempt: (60 * 0.75) * attempt,
        tmpdir=tmp,
    benchmark:
        "benchmark/fair_star_mapping/star_align/{sample}_paired.{species}.{build}.{release}.{datatype}.tsv"
    log:
        "logs/fair_star_mapping/star_align/{sample}_paired.{species}.{build}.{release}.{datatype}.log",
    params:
        extra=dlookup(
            dpath="params/fair_star_mapping/star/align",
            within=config,
            default="--outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --twopassMode Basic",
        ),
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/star/align"


use rule fair_star_mapping_star_align_pair_ended as fair_star_mapping_star_align_single_ended with:
    input:
        fq1="tmp/fair_star_mapping/fastp_trimming_pair_ended/{sample}.fastq",
    output:
        aln=temp(
            "tmp/fair_star_mapping/star_single/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam"
        ),
        log=temp(
            "tmp/fair_star_mapping/star_single/{species}.{build}.{release}.{datatype}/{sample}/Log.out"
        ),
        sj=temp(
            "tmp/fair_star_mapping/star_single/{species}.{build}.{release}.{datatype}/{sample}/SJ.out.tab"
        ),
    log:
        "logs/fair_star_mapping/star_align/{sample}_single.{species}.{build}.{release}.{datatype}.log",
    benchmark:
        "benchmark/fair_star_mapping/star_align/{sample}_single.{species}.{build}.{release}.{datatype}.tsv"
