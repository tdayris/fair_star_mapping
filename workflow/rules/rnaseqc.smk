rule fair_star_mapping_rnaseqc:
    input:
        gtf=getattr(
            lookup(
                query="species == '{species}' & build == '{build}' & release == '{release}'",
                within=genomes,
            ),
            "gtf",
            "reference/annotation/{species}.{build}.{release}.gtf",
        ),
        fasta=getattr(
            lookup(
                query="species == '{species}' & build == '{build}' & release == '{release}'",
                within=genomes,
            ),
            "dna_fasta",
            "reference/sequences/{species}.{build}.{release}.dna.fasta",
        ),
        bam="results/{species}.{build}.{release}.dna/Mapping/{sample}.bam",
        bam_bai="results/{species}.{build}.{release}.dna/Mapping/{sample}.bam.bai",
    output:
        metrics=temp(
            "tmp/fair_star_mapping/rnaseqc/{species}.{build}.{release}.dna/{sample}.metrics.tsv"
        ),
        exon_read=temp(
            "tmp/fair_star_mapping/rnaseqc/{species}.{build}.{release}.dna/{sample}.exon_reads.gct"
        ),
        gene_read=temp(
            "tmp/fair_star_mapping/rnaseqc/{species}.{build}.{release}.dna/{sample}.gene_reads.gct"
        ),
        gene_tpm=temp(
            "tmp/fair_star_mapping/rnaseqc/{species}.{build}.{release}.dna/{sample}.gene_tpm.gct"
        ),
        coverage=temp(
            "tmp/fair_star_mapping/rnaseqc/{species}.{build}.{release}.dna/{sample}.coverage.tsv"
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 45,
        tmpdir=tmp,
    log:
        "logs/fair_star_mapping/rnaseqc/{species}.{build}.{release}/{sample}.log",
    benchmark:
        "benchmark/fair_star_mapping/rnaseqc/{species}.{build}.{release}/{sample}.tsv"
    params:
        extra=dlookup(
            dpath="params/fair_star_mapping/rnaseqc",
            within=config,
            default="",
        ),
        out_prefix="{sample}"
    conda:
        "../envs/rnaseqc.yaml"
    script:
        "../scripts/rnaseqc.py"
