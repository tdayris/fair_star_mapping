import csv
import os
import pandas
import snakemake
import snakemake.utils

from collections import defaultdict
from pathlib import Path
from typing import Any

snakemake.utils.min_version("7.29.0")


container: "docker://snakemake/snakemake:v8.5.3"


# Load and check configuration file
configfile: "config/config.yaml"


snakemake.utils.validate(config, "../schemas/config.schema.yaml")

# Load and check samples properties table
sample_table_path: str = config.get("samples", "config/samples.csv")
with open(sample_table_path, "r") as sample_table_stream:
    dialect: csv.Dialect = csv.Sniffer().sniff(sample_table_stream.read(1024))
    sample_table_stream.seek(0)

samples: pandas.DataFrame = pandas.read_csv(
    filepath_or_buffer=sample_table_path,
    sep=dialect.delimiter,
    header=0,
    index_col=None,
    comment="#",
    dtype=str,
)
samples = samples.where(samples.notnull(), None)
snakemake.utils.validate(samples, "../schemas/samples.schema.yaml")

# This is here for compatibility with
genome_table_path: str = config.get("genomes")
if genome_table_path:
    with open(genome_table_path, "r") as genome_table_stream:
        dialect: csv.Dialect = csv.Sniffer().sniff(genome_table_stream.read(1024))
        genome_table_stream.seek(0)

    genomes: pandas.DataFrame = pandas.read_csv(
        filepath_or_buffer=genome_table_path,
        sep=dialect.delimiter,
        header=0,
        index_col=None,
        comment="#",
        dtype=str,
    )
    genomes = genomes.where(genomes.notnull(), None)
else:
    genomes: pandas.DataFrame = samples[
        ["species", "build", "release"]
    ].drop_duplicates(keep="first", ignore_index=True)
    genomes.to_csv("genomes.csv", sep=",", index=False, header=True)
    config["genomes"] = "genomes.csv"

snakemake.utils.validate(genomes, "../schemas/genomes.schema.yaml")


report: "../report/workflows.rst"


release_list: list[str] = list(set(genomes.release.tolist()))
build_list: list[str] = list(set(genomes.build.tolist()))
species_list: list[str] = list(set(genomes.species.tolist()))
stream_list: list[str] = ["1", "2"]
snakemake_wrappers_prefix: str = "v3.5.2"
tmp: str = f"{os.getcwd()}/tmp"


wildcard_constraints:
    sample=r"|".join(samples.sample_id),
    release=r"|".join(release_list),
    build=r"|".join(build_list),
    species=r"|".join(species_list),
    stream=r"|".join(stream_list),


def dlookup(
    dpath: str | None = None,
    query: str | None = None,
    cols: list[str] | None = None,
    within=None,
    default: str | dict[str, Any] | None = None,
) -> str:
    """
    Return lookup() results or defaults

    dpath   (str | Callable | None): Passed to dpath library
    query   (str | Callable | None): Passed to DataFrame.query()
    cols    (list[str] | None):      The columns to operate on
    within  (object):                The dataframe or mappable object
    default (str):                   The default value to return
    """
    value = None
    try:
        value = lookup(dpath=dpath, query=query, cols=cols, within=within)
    except LookupError:
        value = default
    except WorkflowError:
        value = default
    except KeyError:
        value = default
    except AttributeError:
        value = default

    return value


def get_sjdb_overhang(
    wildcards: snakemake.io.Wildcards,
    samples: pandas.DataFrame = samples,
) -> str:
    """
    Return readlen-1 if available in samples, else 100
    """
    return getattr(
        lookup(
            query="species == '{species}' & build == '{build}' & release == '{release}'",
            within=samples,
        ),
        "readlen",
        "100",
    )


def get_fair_star_mapping_target(
    wildcards: snakemake.io.Wildcards,
    samples: pandas.DataFrame = samples,
    config: dict[str, Any] = config,
) -> dict[str, list[str]]:
    """
    Return the expected list of output files at the end of the pipeline

    Parameters:
    wildcards (snakemake.io.Wildcards): Required for snakemake unpacking function
    samples   (pandas.DataFrame)      : Describe sample names and related paths/genome
    config    (dict[str, Any])        : Configuration file

    Return (dict[str, List(str)]):
    Dictionnary of expected output files
    """
    results: dict[str, list[str]] = {
        "multiqc": [
            "results/QC/MultiQC_FastQC.html",
            "results/QC/MultiQC_FastQC_data.zip",
        ],
        "bams": [],
        "bais": [],
    }
    datatype: str = "dna"
    sample_iterator = zip(
        samples.sample_id,
        samples.species,
        samples.build,
        samples.release,
    )
    for sample, species, build, release in sample_iterator:
        results["multiqc"].append(
            f"results/{species}.{build}.{release}.{datatype}/QC/MultiQC_Mapping.html",
        )
        results["bams"].append(
            f"results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam"
        )
        results["bais"].append(
            f"results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.bam.bai"
        )

    results["multiqc"] = list(set(results["multiqc"]))
    return results
