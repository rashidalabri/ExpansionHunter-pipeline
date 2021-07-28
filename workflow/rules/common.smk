SAMPLES = pd.read_table(config["samples"]).set_index("Sample", drop=False)
METADATA = pd.read_table(config["metadata"]).set_index("Sample name", drop=False)
VARIANTS = config["variants"] 
