rule genotype_sample:
    input:
        cram=get_sample_cram_path_ftp,
        crai=get_sample_crai_path_ftp,
        fa=FTP.remote(config["ref"]["fa"]),
        fai=FTP.remote(config["ref"]["fai"]),
        var="resources/variant_catalog/chunked/{variant}/{variant}.{n}.json"
    params:
        sex=lambda wildcards: METADATA.loc[wildcards['sample'], 'Sex'],
        prefix=lambda wildcards, output: output.json[:-5],
        mode="seeking"
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
        "ExpansionHunter --reads {input.cram} "
        "--reference {input.fa} "
        "--variant-catalog {input.var} "
        "--output-prefix {params.prefix} "
        "--sex {params.sex} "
        "--analysis-mode {params.mode} "
        "2> {log.stderr} 1> {log.stdout}"
