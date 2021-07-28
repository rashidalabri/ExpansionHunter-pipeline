import json
import numpy as np
import random


variant_catalog_file = open(snakemake.input[0], 'r')
variant_catalog = json.load(variant_catalog_file)

if snakemake.config['downsample']:
    random.seed(snakemake.config['downsample_seed'])
    n_samples = min(snakemake.config['downsample_to_size'], len(variant_catalog))
    downsampled = random.sample(variant_catalog, n_samples)
else:
    downsampled = variant_catalog

with open(snakemake.output[0], 'w', encoding='utf-8') as f:
    json.dump(downsampled, f, indent=4)
