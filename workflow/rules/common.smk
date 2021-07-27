def get_download_cram_disk_mb(wildcards):
    if config["eh_analysis_mode"] == 'seeking':
        return 4 * 1024
    else:
        return config["download_cram_disk_gb"] * 1024
