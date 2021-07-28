rule download_reference:
    output:
        protected("resources/reference/GRCh38.fa")
    shell:
        "wget -O {output} {config[reference_url][fa]}"

rule download_reference_index:
    output:
        protected("resources/reference/GRCh38.fa.fai")
    shell:
        "wget -O {output} {config[reference_url][fai]}"

rule download_sample_cram:
    output:
        temp("resources/cram/{sample}/{sample}.cram")
    params:
        url=lambda wildcards: SAMPLES.loc[wildcards['sample'], 'url']
    shell:
        "wget -O {output} {params.url}"

rule download_sample_crai:
    output:
        temp("resources/cram/{sample}/{sample}.cram.crai")
    params:
        url=lambda wildcards: SAMPLES.loc[wildcards['sample'], 'url']
    shell:
        "wget -O {output} {params.url}.crai"