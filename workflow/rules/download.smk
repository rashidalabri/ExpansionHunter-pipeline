SAMPLES = pd.read_table(config["samples"]).set_index("Sample", drop=False)

rule download_reference:
    output:
        protected("resources/reference/GRCh38.fa"),
    params:
        fname=lambda wildcards, output: output[0].split('/')[-1]
    shell:
        "wget -O {output} {config[ref][host]}{config[ref][fa_path]}"

rule download_reference_index:
    output:
        protected("resources/reference/GRCh38.fa.fai")
    shell:
        "wget -O {output} {config[ref][host]}{config[ref][fai_path]}"

rule download_cram:
    output:
        temp("resources/cram/{sample}.cram")
    params:
        download_path=lambda wildcards: SAMPLES.loc[wildcards['sample'], 'url']
    resources:
        disk_mb=get_download_cram_disk_mb
    shell:
        "wget -O {output} {params.download_path}"

rule download_crai:
    output:
        temp("resources/cram/{sample}.cram.crai")
    params:
        download_path=lambda wildcards: SAMPLES.loc[wildcards['sample'], 'url']
    shell:
        "wget -O {output} {params.download_path}.crai"