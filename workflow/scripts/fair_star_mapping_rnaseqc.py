# coding: utf-8

__author__ = "Thibault Dayris"
__mail__ = "thibault.dayris@gustaveroussy.fr"
__copyright__ = "Copyright 2024, Thibault Dayris"
__license__ = "MIT"


from tempfile import TemporaryDirectory
from snakemake import shell

extra = snakemake.params.get("extra", "")
log = snakemake.log_fmt_shell(stdout=True, stderr=True, append=True)

bed = snakemake.input.get("bed", "")
if bed:
    bed = f"--bed {bed}"

fasta = snakemake.input.get("fasta", "")
if fasta:
    fasta = f"--fasta {fasta}"

gene_rpkm = snakemake.output.get("gene_rpkm")
if gene_rpkm:
    extra += "--rpkm"

out_prefix = snakemake.params.get("prefix", "out_prefix")


with TemporaryDirectory() as tempdir:
    shell(
        "rnaseqc {extra} "
        "{bed} {fasta} "
        "--sample {out_prefix} "
        "{snakemake.input.gtf} "
        "{snakemake.input.bam} "
        "{tempdir} {log} "
    )
    shell("ls {tempdir} >> {snakemake.log[0]}")

    metrics = snakemake.output.get("metrics")
    if metrics:
        shell("mv --verbose {tempdir}/{out_prefix}.metrics.tsv {metrics} {log}")

    exon_read = snakemake.output.get("exon_read")
    if exon_read:
        shell("mv --verbose {tempdir}/{out_prefix}.exon_reads.gct {exon_read} {log}")

    gene_read = snakemake.output.get("gene_read")
    if gene_read:
        shell("mv --verbose {tempdir}/{out_prefix}.gene_reads.gct {gene_read} {log}")

    # gene_tpm and gene_rpkm are mutually exclusive
    gene_tpm = snakemake.output.get("gene_tpm")
    if gene_tpm:
        shell("mv --verbose {tempdir}/{out_prefix}.gene_tpm.gct {gene_tpm} {log}")
    elif gene_rpkm:
        shell("mv --verbose {tempdir}/{out_prefix}.gene_rpkm.gct {gene_rpkm} {log}")

    fragment_size = snakemake.output.get("fragment_size")
    if fragment_size and bed:
        shell(
            "mv --verbose {tempdir}/{out_prefix}.fragmentSizes.txt {fragment_size} {log}"
        )

    coverage = snakemake.output.get("coverage")
    if coverage:
        shell("mv --verbose {tempdir}/{out_prefix}.exon_cv.tsv {coverage} {log}")
