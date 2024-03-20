SHELL=/usr/bin/bash
.ONESHELL:
.SHELLFLAGS := -euic
.DELETE_ON_ERROR: linter_info.txt format.txt pipeline.txt

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# List of snakefiles to lint
snakefiles := \
	"../workflow/rules/common.smk" \
	"../workflow/rules/fair_bowtie2_mapping.smk" \
	"../workflow/rules/fair_fastqc_multiqc.smk" \
	"../workflow/rules/fair_genome_indexer.smk" \
	"../workflow/rules/fastp.smk" \
	"../workflow/rules/goleft.smk" \
	"../workflow/rules/multiqc.smk" \
	"../workflow/rules/ngsderive.smk" \
	"../workflow/rules/picard_metrics.smk" \
	"../workflow/rules/rnaseqc.smk" \
	"../workflow/rules/rseqc.smk" \
	"../workflow/rules/sambamba.smk" \
	"../workflow/rules/samtools_stats.smk" \
	"../workflow/rules/star.smk" \
	"../workflow/rules/ucsc.smk" \
	"../workflow/Snakefile"

pythonfiles := \
	"../workflow/scripts/rseqc_tin.py" \
	"../workflow/scripts/rnaseqc.py"

.PHONY: all
all: report.txt


dag.png:
	mamba activate test-snakemake-wrappers && \
	snakemake -s ../workflow/Snakefile \
		--rulegraph --forceall | dot -Tpng > dag.png && \
	cp --verbose dag.png ../dag.png


report.txt: pipeline.txt
	mamba activate test-snakemake-wrappers && \
	snakemake -s ../workflow/Snakefile --profile local \
		--report report.html 2>&1 | tee report.txt


pipeline.txt: linter.txt
	mamba activate test-snakemake-wrappers && \
	snakemake -s ../workflow/Snakefile --profile local  \
		--cores 2 \
		--software-deployment-method apptainer conda \
		2>&1 | tee pipeline.txt


format.txt:
	mamba activate test-snakemake-wrappers && \
	snakefmt $(snakefiles) 2>&1 | tee format.txt


linter.txt: format.txt black.txt
	mamba activate test-snakemake-wrappers && \
	snakemake -s ../workflow/Snakefile  --profile local \
		--lint 2>&1 | tee linter.txt


black.txt:
	mamba activate test-snakemake-wrappers && \
	black $(pythonfiles) 2>&1 | tee black.txt

.PHONY: clean
clean:
	rm -rvf linter.txt \
		   format.txt \
		   reference \
		   results \
		   tmp \
		   logs \
		   benchmark \
		   report.html \
		   report.txt \
		   pipeline.txt \
		   dag.png \
		   black.txt \
		   .java \
		   .wget-hsts \
		   .conda
