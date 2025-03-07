module fair_bowtie2_mapping:
    snakefile:
        config.get(
            "fair_bowtie2_mapping",
            github(
                "tdayris/fair_bowtie2_mapping",
                path="workflow/Snakefile",
                tag="4.4.6",
            ),
        )
    config:
        {**config, "load_fair_genome_indexer": False, "load_fair_fastqc_multiqc": False}


use rule fair_bowtie2_mapping_goleft_indexcov from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_mosdepth from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_ngsderive_encoding from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_ngsderive_instrument from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_ngsderive_readlen from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_picard_create_multiple_metrics from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_rseqc_infer_experiment from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_rseqc_bamstat from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_rseqc_read_gc from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_rseqc_read_distribution from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_rseqc_inner_distance from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_samtools_stats from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_samtools_idxstats from fair_bowtie2_mapping


use rule fair_bowtie2_mapping_mtnucratiocalculator from fair_bowtie2_mapping
