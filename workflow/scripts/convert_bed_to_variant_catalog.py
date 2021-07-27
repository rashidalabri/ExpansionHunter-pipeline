import pandas as pd
import json

bed = pd.read_csv(snakemake.input[0], sep='\t', header=None)
bed.columns = ['chr', 'start', 'stop', 'motif']

variant_catalog = []

for _, row in bed.iterrows():
    locus_id = '{}_{}_{}'.format(row['chr'], row['start'], row['stop'])
    locus_struct = '({})*'.format(row['motif'])
    ref_region = '{}:{}:{}'.format(row['chr'], row['start'], row['stop'])
    variant_catalog.append({
        'LocusId': locus_id,
        'LocusStructure': locus_struct,
        'ReferenceRegion': ref_region,
        'VariantId': locus_id,
        'VariantType': 'Repeat'
    })

with open(snakemake.output[0], 'w') as outfile: 
    json.dump(variant_catalog, outfile, indent=4)