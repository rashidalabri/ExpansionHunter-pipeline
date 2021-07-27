localrules: downsample_variant_catalog, bed_to_variant_catalog

rule bed_to_variant_catalog:
    input:
        "resources/variant_catalog/{variant_catalog}.bed"
    output:
        "resources/variant_catalog/{variant_catalog}.json"
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/convert_bed_to_variant_catalog.py"

rule downsample_variant_catalog:
    input:
        "resources/variant_catalog/{variant}.json"
    output:
        "resources/variant_catalog/downsampled/{variant}.json"
    conda:
        "../envs/numpy.yaml"
    script:
        "../scripts/downsample_variant_catalog.py"
