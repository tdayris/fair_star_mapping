rule fair_star_mapping_star_align_pair_ended:
    input:
        fq1="tmp/fair_star_mapping_fastp_trimming_pair_ended/{sample}.1.fastq",
        fq2="tmp/fair_star_mapping_fastp_trimming_pair_ended/{sample}.2.fastq",
        idx=lambda wildcards: select_star_index(wildcards),
    output:
        aln=temp(
            "tmp/fair_star_mapping_star_align_pair_ended/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam"
        ),
        log=temp(
            "tmp/fair_star_mapping_star_align_pair_ended/{species}.{build}.{release}.{datatype}/{sample}/Log.out"
        ),
        sj=temp(
            "tmp/fair_star_mapping_star_align_pair_ended/{species}.{build}.{release}.{datatype}/{sample}/SJ.out.tab"
        ),
    threads: 20
    resources:
        mem_mb=lambda wildcards, attempt: (1024 * 45) + ((1024 * 10) * attempt),
        runtime=lambda wildcards, attempt: (60 * 0.75) * attempt,
        tmpdir=tmp,
    benchmark:
        "benchmark/fair_star_mapping_star_align_pair_ended/{sample}_paired.{species}.{build}.{release}.{datatype}.tsv"
    log:
        "logs/fair_star_mapping_star_align_pair_ended/{sample}_paired.{species}.{build}.{release}.{datatype}.log",
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_star_align_pair_ended",
            default="--outSAMtype BAM Unsorted --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --twopassMode Basic",
        ),
    wrapper:
        "v5.8.3/bio/star/align"


use rule fair_star_mapping_star_align_pair_ended as fair_star_mapping_star_align_single_ended with:
    input:
        fq1="tmp/fair_star_mapping_fastp_trimming_single_ended/{sample}.fastq",
        idx=lambda wildcards: select_star_index(wildcards),
    output:
        aln=temp(
            "tmp/fair_star_mapping_star_align_single_ended/{species}.{build}.{release}.{datatype}/{sample}/{sample}.bam"
        ),
        log=temp(
            "tmp/fair_star_mapping_star_align_single_ended/{species}.{build}.{release}.{datatype}/{sample}/Log.out"
        ),
        sj=temp(
            "tmp/fair_star_mapping_star_align_single_ended/{species}.{build}.{release}.{datatype}/{sample}/SJ.out.tab"
        ),
    log:
        "logs/fair_star_mapping_star_align_single_ended/{sample}_single.{species}.{build}.{release}.{datatype}.log",
    benchmark:
        "benchmark/fair_star_mapping_star_align_single_ended/{sample}_single.{species}.{build}.{release}.{datatype}.tsv"
    params:
        extra=lookup_config(
            dpath="params/fair_star_mapping_star_align_single_ended",
            default="--outSAMtype BAM Unsorted --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --twopassMode Basic",
        ),
