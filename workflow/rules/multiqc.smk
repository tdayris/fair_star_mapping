rule fair_star_mapping_multiqc_config:
    input:
        "tmp/fair_fastqc_multiqc/bigr_logo.png",
    output:
        temp("tmp/fair_star_mapping/multiqc_config.yaml"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 512,
        runtime=lambda wildcards, attempt: attempt * 5,
        tmpdir=tmp,
    localrule: True
    log:
        "logs/fair_star_mapping/multiqc_config.log",
    benchmark:
        "benchmark/fair_star_mapping/multiqc_config.tsv"
    params:
        extra=lambda wildcards, input: {
            "title": "Mapping quality control report",
            "subtitle": "Produced on raw fastq recieved from sequencer",
            "intro_text": (
                "This pipeline building this report has "
                "no information about sequencing protocol, "
                "or wet-lab experimental design."
            ),
            "report_comment": (
                "This report was generated using: "
                "https://github.com/tdayris/fair_star_mapping"
            ),
            "show_analysis_paths": False,
            "show_analysis_time": False,
            "custom_logo": input[0],
            "custom_logo_url": "https://bioinfo_gustaveroussy.gitlab.io/bigr/webpage/",
            "custom_logo_title": "Bioinformatics Platform @ Gustave Roussy",
            "report_header_info": [
                {"Contact E-mail": "bigr@gustaveroussy.fr"},
                {"Application type": "Spliced reads"},
                {"Project Type": "Mapping"},
            ],
            "software_versions": {
                "Quality controls": {
                    "fastqc": "1.12.1",
                    "fastq_screen": "0.15.3",
                    "bowtie2": "1.3.1",
                    "multiqc": "1.20.0",
                },
                "Mapping": {
                    "star": "2.7.11b",
                    "sambamba": "1.0",
                    "samtools": "1.19.2",
                    "picard": "3.1.1",
                    "rseqc": "5.0.3",
                    "fastp": "0.23.4",
                    "ngsderive": "3.3.2",
                    "goleft": "0.2.4",
                    "rnaseqc": "2.4.2",
                },
                "Pipeline": {
                    "snakemake": "8.5.3",
                    "fair_bowtie2_mapping": "3.2.0",
                    "fair_star_mapping": "1.0.0",
                    "fair_fastqc_multiqc": "2.1.2",
                    "fair_genome_indexer": "3.2.2",
                },
            },
            "disable_version_detection": True,
            "run_modules": [
                "fastqc",
                "fastq_screen",
                "fastp",
                "star",
                "samtools",
                "picard",
                "rseqc",
                "ngsderive",
                "goleft_indexcov",
                "rnaseqc",
            ],
            "report_section_order": {
                "fastq_screen": {"order": 1000},
                "ngsderive": {"order": 950},
                "fastqc": {"order": 900},
                "fastp": {"order": 890},
                "star": {"order": 880},
                "picard": {"order": 870},
                "samtools": {"order": 860},
                "rseqc": {"order": 850},
                "goleft_indexcov": {"order": 840},
                "rnaseqc": {"order": 830},
                "software_versions": {"order": -1000},
            },
        },
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/fair_star_mapping_multiqc_config.py"


rule fair_star_mapping_multiqc_report:
    input:
        config="tmp/fair_star_mapping/multiqc_config.yaml",
        logo="tmp/fair_fastqc_multiqc/bigr_logo.png",
        fastqc_pair_ended=collect(
            "results/QC/report_pe/{sample.sample_id}.{stream}_fastqc.zip",
            sample=lookup(
                query="downstream_file == downstream_file & species == '{species}' & build == '{build}' & release == '{release}'",
                within=samples,
            ),
            stream=stream_list,
        ),
        fastqc_single_ended=collect(
            "results/QC/report_pe/{sample.sample_id}_fastqc.zip",
            sample=lookup(
                query="downstream_file != downstream_file & species == '{species}' & build == '{build}' & release == '{release}'",
                within=samples,
            ),
        ),
        fastp_pair_ended=collect(
            "tmp/fair_star_mapping/fastp_trimming_pair_ended/{sample.sample_id}.fastp.json",
            sample=lookup(
                query="downstream_file == downstream_file & species == '{species}' & build == '{build}' & release == '{release}'",
                within=samples,
            ),
        ),
        fastp_single_ended=collect(
            "tmp/fair_star_mapping/fastp_trimming_single_ended/{sample.sample_id}.fastp.json",
            sample=lookup(
                query="downstream_file != downstream_file & species == '{species}' & build == '{build}' & release == '{release}'",
                within=samples,
            ),
        ),
        rseqc_infer_experiment=collect(
            "tmp/fair_star_mapping/rseqc_infer_experiment/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.infer_experiment.txt",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        rseqc_bamstat=collect(
            "tmp/fair_star_mapping/rseqc_bamstat/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.bamstat.txt",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        rseqc_read_gc=collect(
            "tmp/fair_star_mapping/rseqc_read_gc/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.GC.xls",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        rseqc_read_distribution=collect(
            "tmp/fair_star_mapping/rseqc_read_distribution/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.txt",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        rseqc_inner_distance=collect(
            "tmp/fair_star_mapping/rseqc_inner_distance/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.inner_distance_freq.txt",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        rseqc_tin=collect(
            "tmp/fair_star_mapping/rseqc_tin/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.summary.txt",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        rnaseqc_metrics=collect(
            "tmp/fair_star_mapping/rnaseqc/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.metrics.tsv",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        rnaseqc_coverage=collect(
            "tmp/fair_star_mapping/rnaseqc/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.coverage.tsv",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        samtools_stat=collect(
            "tmp/fair_star_mapping/samtools_stats/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}.txt",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        star_pair_ended=collect(
            "tmp/fair_star_mapping/star_paired/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}/Log.out",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}' & downstream_file == downstream_file",
                within=samples,
            ),
        ),
        star_single_ended=collect(
            "tmp/fair_star_mapping/star_single/{sample.species}.{sample.build}.{sample.release}.dna/{sample.sample_id}/Log.out",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}' & downstream_file != downstream_file",
                within=samples,
            ),
        ),
        picard_collect_multiple_metrics=collect(
            "tmp/fair_star_mapping/picard_create_multiple_metrics/{sample.species}.{sample.build}.{sample.release}.dna/stats/{sample.sample_id}{ext}",
            ext=[
                ".alignment_summary_metrics",
                ".insert_size_metrics",
                ".insert_size_histogram.pdf",
                ".base_distribution_by_cycle_metrics",
                ".base_distribution_by_cycle.pdf",
                ".gc_bias.detail_metrics",
                ".gc_bias.summary_metrics",
                ".gc_bias.pdf",
            ],
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
        ),
        goleft_indexcov=collect(
            "tmp/fair_star_mapping/goleft/indexcov/{sample.species}.{sample.release}.{sample.build}/{sample.sample_id}-indexcov.{ext}",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
            ext=["ped", "roc"],
        ),
        ngsderive_encoding=collect(
            "tmp/fair_star_mapping/ngsderive/{subcommand}/{sample.species}.{sample.build}/{sample.release}.dna/{sample.sample_id}.{subcommand}.tsv",
            sample=lookup(
                query="species == '{species}' & release == '{release}' & build == '{build}'",
                within=samples,
            ),
            subcommand=["encoding", "instrument", "readlen"],
        ),
    output:
        report(
            "results/{species}.{build}.{release}.dna/QC/MultiQC_Mapping.html",
            caption="../report/multiqc.rst",
            category="Quality Controls",
            subcategory="General",
            labels={
                "report": "html",
                "step": "Mapping",
                "organism": "{species}.{build}.{release}.dna",
            },
        ),
        "results/{species}.{build}.{release}.dna/QC/MultiQC_Mapping_data.zip",
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: (2 * 1024) * attempt,
        runtime=lambda wildcards, attempt: int(60 * 0.5) * attempt,
        tmpdir=tmp,
    params:
        extra=dlookup(dpath="params/multiqc", within=config, default="--verbose"),
        use_input_files_only=True,
    log:
        "logs/fair_star_mapping/multiqc_report/{species}.{build}.{release}.dna.log",
    benchmark:
        "benchmark/fair_star_mapping/multiqc_report/{species}.{build}.{release}.dna.tsv"
    wrapper:
        f"{snakemake_wrappers_prefix}/bio/multiqc"
