SAMPLES = pd.read_table(config["samples"]).set_index("Sample", drop=False)
METADATA = pd.read_table(config["metadata"]).set_index("Sample name", drop=False)
VARIANTS = config["variants"] 

def get_sample_cram_url(wildcards):
    url = "1000genomes/1000G_2504_high_coverage/data".split("/")
    url += SAMPLES.loc[wildcards.sample, "url"].split("/")[-2:]
    return "s3://" + "/".join(url)

def get_sample_crai_url(wildcards):
    return get_sample_cram_url(wildcards) + ".crai"

def get_genotype_mem_mb(wildcards):
    if config["eh_analysis_mode"] == "seeking":
        return 6 * 1024
    else:
        return 32 * 1024
