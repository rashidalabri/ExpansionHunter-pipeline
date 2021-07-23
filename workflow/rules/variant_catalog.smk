rule downsample_variant:
    input:
        "resources/variant_catalog/{variant}.json"
    output:
        "resources/variant_catalog/downsampled/{variant}.json"
    conda:
        "../envs/numpy.yaml"
    script:
        "../scripts/downsample_variant_catalog.py"