module fair_genome_indexer:
    snakefile:
        config.get(
            "fair_genome_indexer_snakefile",
            github(
                "tdayris/fair_genome_indexer",
                path="workflow/Snakefile",
                tag="3.9.2",
            ),
        )
    config:
        config


use rule * from fair_genome_indexer
