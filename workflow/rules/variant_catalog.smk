localrules: downsample_variant_catalog, filter_variant_catalog

rule downsample_variant_catalog:
    input:
        "resources/variant_catalog/filtered/{variant}.json"
    output:
        "resources/variant_catalog/downsampled/{variant}.json"
    conda:
        "../envs/numpy.yaml"
    script:
        "../scripts/downsample_variant_catalog.py"
