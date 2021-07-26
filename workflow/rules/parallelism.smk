localrules: split_variant_catalog, merge_eh_vcf, merge_eh_json

N = range(0, config["n_chunks"])

rule split_variant_catalog:
    input:
        "resources/variant_catalog/downsampled/{variant}.json"
    output:
        expand("resources/variant_catalog/chunked/{variant}/{variant}.{n}.json", n=N, allow_missing=True)
    script:
        "../scripts/split_variant_catalog.py"

rule merge_eh_realigned_bam:
    input:
        expand("results/{variant}/{sample}/{sample}_realigned.{n}.bam", n=N, allow_missing=True)
    output:
        protected("results/{variant}/{sample}/{sample}_realigned.bam")
    threads: 8
    wrapper:
        "0.77.0/bio/samtools/merge"

rule merge_eh_vcf:
    input:
        calls=expand("results/{variant}/{sample}/{sample}.{n}.vcf", n=N, allow_missing=True)
    output:
        protected("results/{variant}/{sample}/{sample}.vcf")
    params:
        ""  # optional parameters for bcftools concat (except -o)
    wrapper:
        "0.77.0/bio/bcftools/merge"

rule merge_eh_json:
    input:
        expand("results/{variant}/{sample}/{sample}.{n}.json", n=N, allow_missing=True)
    output:
        protected("results/{variant}/{sample}/{sample}.json")
    script:
        "../scripts/merge_json.py"

rule index_eh_realigned_bam:
    input:
        "results/{variant}/{sample}/{sample}_realigned.bam"
    output:
        protected("results/{variant}/{sample}/{sample}_realigned.bam.bai")
    log:
        "logs/samtools_index/{variant}/{sample}.log"
    cache: True
    threads: 8
    wrapper:
        "0.77.0/bio/samtools/index"