import json
import math

variant_file = open(snakemake.input[0], 'r')
variant = json.load(variant_file)

n_variants = len(variant)
n_chunks = len(snakemake.output)
variant_per_chunk =  math.ceil(n_variants / n_chunks)

n_chunks_written = 0
for i in range(0, n_variants, variant_per_chunk):
    chunk = variant[i:i + variant_per_chunk]
    with open(snakemake.output[n_chunks_written], 'w', encoding='utf-8') as f:
        json.dump(chunk, f)
    n_chunks_written += 1

assert n_chunks == n_chunks_written