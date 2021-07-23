import json

merged = []

for chunk_path in snakemake.input:
    chunk_file = open(chunk_path, 'r')
    chunk = json.load(chunk_file)
    merged += chunk
    
with open(snakemake.output[0], 'w', encoding='utf-8') as f:
    json.dump(merged, f, indent=4)