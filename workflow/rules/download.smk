rule download_reference:
    output:
        protected("resources/reference/GRCh38.fa")
    conda:
        "../envs/awscli.yaml"
    shell:
        "aws s3 cp {config[reference_url][fa]} {output} --no-sign-request"

rule download_reference_index:
    output:
        protected("resources/reference/GRCh38.fa.fai")
    conda:
        "../envs/awscli.yaml"
    shell:
        "aws s3 cp {config[reference_url][fa]} {output} --no-sign-request"

rule download_sample_cram:
    output:
        temp("resources/cram/{sample}/{sample}.cram")
    params:
        url=get_sample_cram_url
    conda:
        "../envs/awscli.yaml"
    resources:
        disk_mb=32768
    shell:
        "aws s3 cp {params.url} {output} --no-sign-request"

rule download_sample_crai:
    output:
        temp("resources/cram/{sample}/{sample}.cram.crai")
    params:
        url=get_sample_crai_url
    conda:
        "../envs/awscli.yaml"
    shell:
        "aws s3 cp {params.url} {output} --no-sign-request"

rule build_ref_cache:
    input:
        script="workflow/scripts/seq_cache_populate.pl",
        fa="resources/reference/GRCh38.fa",
        fai="resources/reference/GRCh38.fa.fai"
    output:
        directory("resources/reference/ref_cache")
    conda:
        "../envs/perl.yaml"
    envmodules:
        "perl/5.30.2"
    shell:
        "perl {input.script} -root {output} {input.fa}"
