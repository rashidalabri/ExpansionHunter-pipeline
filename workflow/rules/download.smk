SAMPLES = pd.read_table(config["samples"]).set_index("Sample", drop=False)

def get_download_cram_disk_mb(wildcards):
    return config["download_cram_disk_gb"] * 1024

rule download_reference:
    output:
        fa=protected("resources/reference/GRCh38.fa"),
        fai=protected("resources/reference/GRCh38.fa.fai")
    cache: True
    shell:
        "wget -O {output[fa]} {config[ref][host]}{config[ref][fa_path]} &&"
        "wget -O {output[fai]} {config[ref][host]}{config[ref][fai_path]}"

rule download_cram:
    output:
        temp("resources/cram/{sample}.cram")
    params:
        download_path=lambda wildcards: SAMPLES.loc[wildcards['sample'], 'url']
    cache: True
    resources:
        disk_mb=get_download_cram_disk_mb
    shell:
        "wget -O {output} {params.download_path}"

rule download_crai:
    output:
        temp("resources/cram/{sample}.cram.crai")
    params:
        download_path=lambda wildcards: SAMPLES.loc[wildcards['sample'], 'url']
    cache: True
    shell:
        "wget -O {output} {params.download_path}.crai"