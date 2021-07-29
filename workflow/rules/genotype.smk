rule genotype_sample:
    input:
        cram="resources/cram/{sample}/{sample}.cram",
        crai="resources/cram/{sample}/{sample}.cram.crai",
        fa="resources/reference/GRCh38.fa",
        fai="resources/reference/GRCh38.fa.fai",
        ref_cache=directory("resources/reference/ref_cache"),
        var="resources/variant_catalog/chunked/{variant}/{variant}.{n}.json"
    params:
        sex=lambda wildcards: METADATA.loc[wildcards['sample'], 'Sex'],
        prefix=lambda wildcards, output: output.json[:-5],
        mode=config["eh_analysis_mode"]
    output:
        json=temp("results/{variant}/{sample}/{sample}_{n}.json"),
        vcf=temp("results/{variant}/{sample}/{sample}_{n}.vcf"),
        bam=temp("results/{variant}/{sample}/{sample}_{n}_realigned.bam"),
    conda:
        "../envs/expansionhunter.yaml"
    envmodules:
        "expansionhunter/4.0.2"
    log:
        stdout="logs/expansionhunter/{variant}/{sample}/{sample}.{n}.stdout.log",
        stderr="logs/expansionhunter/{variant}/{sample}/{sample}.{n}.stderr.log"
    shell:
        "export REF_PATH='{input.ref_cache}/%2s/%2s/%s:http://www.ebi.ac.uk/ena/cram/md5/%s' && "
        "export REF_CACHE='{input.ref_cache}/%2s/%2s/%s' && "
        "ExpansionHunter --reads {input.cram} "
        "--reference {input.fa} "
        "--variant-catalog {input.var} "
        "--output-prefix {params.prefix} "
        "--sex {params.sex} "
        "--analysis-mode {params.mode} "
        "2> {log.stderr} 1> {log.stdout}"
