# coding: utf-8

"""Snakemake wrapper for RSeQC tin.py"""

__author__ = "Thibault Dayris"
__mail__ = "thibault.dayris@gustaveroussy.fr"
__copyright__ = "Copyright 2024, Thibault Dayris"
__license__ = "MIT"

from snakemake import shell

extra = snakemake.params.get("extra", "")
log = snakemake.log_fmt_shell(stdout=False, stderr=True)

shell(
    "tin.py {extra} "
    "--input {snakemake.input.aln} "
    "--refgene {snakemake.input.refgene} "
    "> {snakemake.output} {log}"
)
