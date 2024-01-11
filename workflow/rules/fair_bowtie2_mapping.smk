module fair_bowtie2_mapping:
    snakefile:
        github("tdayris/fair_bowtie2_mapping", path="workflow/Snakefile", tag="2.2.7")
    config:
        {
            "samples": config.get("samples", "config/samples.csv"),
            "params": config.get("params", {}),
            "load_fair_genome_indexer": False,
            "genomes": config.get("genomes", "genomes.csv"),
        }


use rule sambamba_sort from fair_bowtie2_mapping as fair_bowtie2_mapping_sambamba_sort with:
    input:
        "tmp/star/{species}.{build}.{release}.{datatype}/{sample}_raw.bam",


use rule sambamba_view from fair_bowtie2_mapping as fair_bowtie2_mapping_sambamba_view


use rule sambamba_markdup from fair_bowtie2_mapping as fair_bowtie2_mapping_sambamba_markdup


use rule sambamba_index from fair_bowtie2_mapping as fair_bowtie2_mapping_sambamba_index


rule fastp_trimming_pair_ended from fair_bowtie2_mapping as fair_bowtie2_mapping_fastp_trimming_pair_ended


use rule fastp_trimming_single_ended from fair_bowtie2_mapping as fair_bowtie2_mapping_fastp_trimming_single_ended


use rule fastqc_pair_ended from fair_bowtie2_mapping as fair_bowtie2_mapping_fastqc_pair_ended


use rule fastqc_single_ended from fair_bowtie2_mapping as fair_bowtie2_mapping_fastqc_single_ended


use rule picard_create_multiple_metrics from fair_bowtie2_mapping as fair_bowtie2_mapping_picard_create_multiple_metrics


use rule samtools_stats from fair_bowtie2_mapping as fair_bowtie2_mapping_samtools_stats


use rule multiqc_report from fair_bowtie2_mapping as fair_bowtie2_mapping_multiqc_report with:
    input:
        unpack(get_fair_star_mapping_multiqc_input),