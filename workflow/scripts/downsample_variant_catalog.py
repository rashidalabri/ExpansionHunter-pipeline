import json
import numpy as np
import random

variant_catalog_file = open(snakemake.input[0], 'r')
variant_catalog = json.load(variant_catalog_file)
downsampled = []

if snakemake.config['downsample']:
    random.seed(snakemake.config['downsample_seed'])

    chroms = ['chr{}'.format(n) for n in range(1, 22+1)] + ['chrX', 'chrY']

    variant_catalog_chrom = {chrom: [] for chrom in chroms}

    for variant in variant_catalog:
        chrom = variant['LocusId'].split('_')[0]
        variant_catalog_chrom[chrom].append(variant)

    n_samples_per_chrom = snakemake.config['downsample_to_size'] // len(chroms)

    for chrom in variant_catalog_chrom:
        n_samples = min(n_samples_per_chrom, len(variant_catalog_chrom[chrom]))
        sampled = random.sample(variant_catalog_chrom[chrom], n_samples)
        downsampled += sampled
        for s in sampled:
            variant_catalog.remove(s)
    
    # Sample remaining randomly from entire catalog
    n_remaining = snakemake.config['downsample_to_size'] - len(downsampled)
    sampled = random.sample(variant_catalog, n_remaining)
    downsampled += sampled
else:
    downsampled = variant_catalog

with open(snakemake.output[0], 'w', encoding='utf-8') as f:
    json.dump(downsampled, f, indent=4)

