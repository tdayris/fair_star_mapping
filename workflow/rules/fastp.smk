"""
## Memory
Requires a job with at most 3955.46  Mb,
 on average 2431.49 ± 1520.85 Mb, 
on Gustave Roussy's HPC Flamingo, on a 56.0  Mb dataset.
## Time
A job took 0:06:30 to proceed,
on average 0:02:12 ± 0:01:57
"""


rule fair_star_mapping_fastp_trimming_pair_ended:
    input:
        sample=expand(
            "tmp/fair_fastqc_multiqc_link_or_concat_pair_ended_input/{sample}.{stream}.fastq.gz",
            stream=stream_tuple,
            allow_missing=True,
        ),
    output:
        trimmed=temp(
            expand(
                "tmp/fair_star_mapping_fastp_trimming_pair_ended/{sample}.{stream}.fastq",
                stream=stream_tuple,
                allow_missing=True,
            )
        ),
        html=report(
            "results/QC/report_pe/{sample}.html",
            caption="../report/fastp.rst",
            category="Quality Controls",
            subcategory="Trimming",
            labels={
                "report": "html",
                "sample": "{sample}",
                "library": "pair_ended",
            },
        ),
        json=temp("tmp/fair_star_mapping_fastp_trimming_pair_ended/{sample}.fastp.json"),
    threads: 20
    resources:
        mem_mb=lambda wildcards, attempt: 3_000 + (1_000 * attempt),
        runtime=lambda wildcards, attempt: 15 * attempt,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping_fastp_trimming_pair_ended/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_fastp_trimming_pair_ended/{sample}.tsv"
    params:
        adapters=lookup_config(
            dpath="params/fair_star_mapping_fastp_trimming_pair_ended/adapters",
            default="",
        ),
        extra=lookup_config(
            dpath="params/fair_star_mapping_fastp_trimming_pair_ended/extra",
            default="--cut_front --cut_tail --cut_window_size 6 --cut_mean_quality 10 --unqualified_percent_limit 50 --n_base_limit 7 --average_qual 0 --length_required 15 --overrepresentation_analysis",
        ),
    wrapper:
        "v5.6.0/bio/fastp"


use rule fair_star_mapping_fastp_trimming_pair_ended as fair_star_mapping_fastp_trimming_single_ended with:
    input:
        sample=[
            "tmp/fair_fastqc_multiqc_link_or_concat_single_ended_input/{sample}.fastq.gz"
        ],
    output:
        trimmed=temp("tmp/fair_star_mapping_fastp_trimming_single_ended/{sample}.fastq"),
        html=report(
            "results/QC/report_se/{sample}.html",
            caption="../report/fastp.rst",
            category="Quality Controls",
            subcategory="Trimming",
            labels={
                "report": "html",
                "sample": "{sample}",
                "library": "single_ended",
            },
        ),
        json=temp(
            "tmp/fair_star_mapping_fastp_trimming_single_ended/{sample}.fastp.json"
        ),
    log:
        "logs/fair_star_mapping_fastp_trimming_single_ended/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping_fastp_trimming_single_ended/{sample}.tsv"
    params:
        adapters=lookup_config(
            dpath="params/fair_star_mapping_fastp_trimming_single_ended/adapters",
            default="",
        ),
        extra=lookup_config(
            dpath="params/fair_star_mapping_fastp_trimming_single_ended/extra",
            default="--cut_front --cut_tail --cut_window_size 6 --cut_mean_quality 10 --unqualified_percent_limit 50 --n_base_limit 7 --average_qual 0 --length_required 15 --overrepresentation_analysis",
        ),
