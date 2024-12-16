import csv
import os
import pandas
import snakemake
import snakemake.utils

from typing import Any, Callable, NamedTuple

snakemake_min_version: str = "8.13.7"
snakemake.utils.min_version(snakemake_min_version)

snakemake_docker_image: str = "docker://snakemake/snakemake:v8.20.5"


container: snakemake_docker_image


# Load and check configuration file
default_config_file: str = "config/config.yaml"


configfile: default_config_file


snakemake.utils.validate(config, "../schemas/config.schema.yaml")


# Load and check samples properties table
def load_table(path: str) -> pandas.DataFrame:
    """
    Load a table in memory, automatically inferring column separators

    Parameters:
    path (str): Path to the table to be loaded

    Return
    (pandas.DataFrame): The loaded table
    """
    with open(path, "r") as table_stream:
        dialect: csv.Dialect = csv.Sniffer().sniff(table_stream.readline())
        table_stream.seek(0)

    # Load table
    table: pandas.DataFrame = pandas.read_csv(
        path,
        sep=dialect.delimiter,
        header=0,
        index_col=None,
        comment="#",
        dtype=str,
    )

    # Remove empty lines
    table = table.where(table.notnull(), None)

    return table


def load_genomes(
    path: str | None = None, samples: pandas.DataFrame | None = None
) -> pandas.DataFrame:
    """
    Load genome file, build it if genome file is missing and samples is not None.

    Parameters:
    path    (str)               : Path to genome file
    samples (pandas.DataFrame)  : Loaded samples
    """
    if path is not None:
        genomes: pandas.DataFrame = load_table(path)

        if samples is not None:
            genomes = used_genomes(genomes, samples)
        return genomes

    elif samples is not None:
        return samples[["species", "build", "release"]].drop_duplicates(
            ignore_index=True
        )

    raise ValueError(
        "Provide either a path to a genome file, or a loaded samples table"
    )


def used_genomes(
    genomes: pandas.DataFrame, samples: pandas.DataFrame | None = None
) -> tuple[str]:
    """
    Reduce the number of genomes to download to the strict minimum
    """
    if samples is None:
        return genomes

    return genomes.loc[
        genomes.species.isin(samples.species.tolist())
        & genomes.build.isin(samples.build.tolist())
        & genomes.release.isin(samples.release.tolist())
    ]


# Load and check samples properties tables
try:
    if (samples is None) or samples.empty():
        sample_table_path: str = config.get("samples", "config/samples.csv")
        samples: pandas.DataFrame = load_table(sample_table_path)
except NameError:
    sample_table_path: str = config.get("samples", "config/samples.csv")
    samples: pandas.DataFrame = load_table(sample_table_path)

snakemake.utils.validate(samples, "../schemas/samples.schema.yaml")


# Load and check genomes properties table
genomes_table_path: str = config.get("genomes", "config/genomes.csv")
try:
    if (genomes is None) or genomes.empty:
        genomes: pandas.DataFrame = load_genomes(genomes_table_path, samples)
except NameError:
    genomes: pandas.DataFrame = load_genomes(genomes_table_path, samples)

snakemake.utils.validate(genomes, "../schemas/genomes.schema.yaml")


report: "../report/workflows.rst"


release_tuple: tuple[str] = tuple(set(genomes.release.tolist()))
build_tuple: tuple[str] = tuple(set(genomes.build.tolist()))
species_tuple: tuple[str] = tuple(set(genomes.species.tolist()))
datatype_tuple: tuple[str] = ("dna", "cdna", "all", "transcripts")
gxf_tuple: tuple[str] = ("gtf", "gff3")
id2name_tuple: tuple[str] = ("t2g", "id_to_gene")
tmp: str = f"{os.getcwd()}/tmp"
samples_id_tuple: tuple[str] = tuple(samples.sample_id)
stream_tuple: tuple[str] = ("1", "2")


wildcard_constraints:
    sample=r"|".join(samples_id_tuple),
    release=r"|".join(release_tuple),
    build=r"|".join(build_tuple),
    species=r"|".join(species_tuple),
    datatype=r"|".join(datatype_tuple),
    stream=r"|".join(stream_tuple),


def lookup_config(
    dpath: str, default: str | None = None, config: dict[str, Any] = config
) -> str:
    """
    Run lookup function with default parameters in order to search a key in configuration and return a default value
    """
    value: str | None = default

    try:
        value = lookup(dpath=dpath, within=config)
    except LookupError:
        value = default
    except WorkflowError:
        value = default

    return value


def lookup_genomes(
    wildcards: snakemake.io.Wildcards,
    key: str,
    default: str | list[str] | None = None,
    genomes: pandas.DataFrame = genomes,
    query: str = "species == '{wildcards.species}' & build == '{wildcards.build}' & release == '{wildcards.release}'",
) -> str:
    """
    Run lookup function with default parameters in order to search user-provided sequence/annotation files
    """
    query: str = query.format(wildcards=wildcards)
    query_result: str | float = getattr(
        lookup(query=query, within=genomes), key, default
    )
    if (query_result != query_result) or (query_result is None):
        # Then the result of the query is nan
        return default
    return query_result


def genome_property(wildcards: snakemake.io.Wildcards) -> str:
    """
    Format genome property from wildcards
    """
    return "{wildcards.species}.{wildcards.build}.{wildcards.release}".format(
        wildcards=wildcards
    )


def get_sjdb_overhang(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return readlen-1 if available in samples, else 100
    """
    return lookup_genomes(
        wildcards=wildcards,
        key="readlen",
        default="100",
        genomes=genomes,
    )


def get_dna_fasta(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final DNA fasta sequences
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/sequences/{gp}/{gp}.dna.fasta"
    return lookup_genomes(
        wildcards,
        key="dna_fasta",
        default=default,
        genomes=genomes,
    )


def get_cdna_fasta(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final cDNA fasta sequences
    """
    gp: str = genome_property(wildcards)
    default = f"reference/sequences/{gp}/{gp}.cdna.fasta"
    return lookup_genomes(
        wildcards,
        key="cdna_fasta",
        default=default,
        genomes=genomes,
    )


def get_transcripts_fasta(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final cDNA transcripts fasta sequences
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/sequences/{gp}/{gp}.transcripts.fasta"
    return lookup_genomes(
        wildcards,
        key="transcripts_fasta",
        default=default,
        genomes=genomes,
    )


def select_fasta(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Evaluates the {datatype} wildcard, and return the right fasta file
    """
    return branch(
        condition=str(wildcards.datatype).lower(),
        cases={
            "dna": get_dna_fasta(wildcards),
            "cdna": get_cdna_fasta(wildcards),
            "transcripts": get_transcripts_fasta(wildcards),
        },
    )


def get_dna_fai(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final DNA fasta sequences index
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/sequences/{gp}/{gp}.dna.fasta.fai"
    return lookup_genomes(
        wildcards,
        key="dna_fai",
        default=default,
        genomes=genomes,
    )


def get_cdna_fai(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final cDNA fasta sequences index
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/sequences/{gp}/{gp}.cdna.fasta.fai"
    return lookup_genomes(
        wildcards,
        key="cdna_fai",
        default=default,
        genomes=genomes,
    )


def get_transcripts_fai(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final cDNA transcripts fasta sequences index
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/sequences/{gp}/{gp}.transcripts.fasta.fai"
    return lookup_genomes(
        wildcards,
        key="transcripts_fai",
        default=default,
        genomes=genomes,
    )


def select_fai(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Evaluates the {datatype} wildcard, and return the right fasta index file
    """
    return branch(
        condition=str(wildcards.datatype).lower(),
        cases={
            "dna": get_dna_fai(wildcards),
            "cdna": get_cdna_fai(wildcards),
            "transcripts": get_transcripts_fai(wildcards),
        },
    )


def get_gtf(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final genome annotation (GTF formatted)
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/annotation/{gp}/{gp}.gtf"
    return lookup_genomes(
        wildcards,
        key="gtf",
        default=default,
        genomes=genomes,
    )


def get_gff(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the final genome annotation (GFF3 formatted)
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/annotation/{gp}/{gp}.gff3"
    return lookup_genomes(
        wildcards,
        key="gff3",
        default=default,
        genomes=genomes,
    )


def get_dna_star_index(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the STAR DNA index
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/star_index/{gp}.dna"
    return lookup_genomes(
        wildcards=wildcards,
        key="star_dna_index",
        default=default,
        genomes=genomes,
    )


def get_transcripts_star_index(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the STAR transcripts index
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/star_index/{gp}.transcripts"
    return lookup_genomes(
        wildcards=wildcards,
        key="star_dna_index",
        default=default,
        genomes=genomes,
    )


def get_cdna_star_index(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return path to the STAR cDNA index
    """
    gp: str = genome_property(wildcards)
    default: str = f"reference/star_index/{gp}.cdna"
    return lookup_genomes(
        wildcards=wildcards,
        key="star_dna_index",
        default=default,
        genomes=genomes,
    )


def select_star_index(
    wildcards: snakemake.io.Wildcards,
    genomes: pandas.DataFrame = genomes,
) -> str:
    """
    Return the right STAR index
    """
    return branch(
        condition=str(wildcards.datatype).lower(),
        cases={
            "dna": get_dna_star_index(wildcards=wildcards, genomes=genomes),
            "cdna": get_cdna_star_index(wildcards=wildcards, genomes=genomes),
            "transcripts": get_transcripts_star_index(
                wildcards=wildcards, genomes=genomes
            ),
        },
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
        "regtools": [],
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
        results["regtools"].append(
            f"results/{species}.{build}.{release}.{datatype}/Mapping/{sample}.regtools_junctions_annotated.bed"
        )

    results["multiqc"] = list(set(results["multiqc"]))
    return results
