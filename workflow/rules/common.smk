from snakemake.remote.FTP import RemoteProvider as FTPRemoteProvider

SAMPLES = pd.read_table(config["samples"]).set_index("Sample", drop=False)
METADATA = pd.read_table(config["metadata"]).set_index("Sample name", drop=False)
VARIANTS = config["variants"] 

FTP = FTPRemoteProvider()

def get_sample_cram_path_str(wildcards):
    return SAMPLES.loc[wildcards.sample, 'url'][6:]

def get_sample_cram_path_ftp(wildcards):
    url = get_sample_cram_path_str(wildcards)
    return FTP.remote(url)

def get_sample_crai_path_ftp(wildcards):
    url = get_sample_cram_path_str(wildcards) + '.crai'
    return FTP.remote(url)

