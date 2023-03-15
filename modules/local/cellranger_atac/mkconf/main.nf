process CELLRANGER_ATAC_MKCONF {
    label 'process_low'

    if (params.enable_conda) {
        exit 1, "Conda environments cannot be used when using the Cell Ranger tool. Please use docker or singularity containers."
    }

    container "python"

    input:
    path fasta
    path gtf
    val reference_name

    output:
    path "cellranger_atac.config", emit: config

    script:
    def args = task.ext.args ?: ''
    """
    mkconf.py \\
        --gtf ${gtf} \\
        --fasta ${fasta} \\
        --genome ${reference_name} \\
        ${args}
    """
}