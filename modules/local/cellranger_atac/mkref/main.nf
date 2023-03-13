#!/usr/bin/env nextflow

process CELLRANGER_ATAC_MKREF {
    tag   'mkref'
    label 'process_med'

    if (params.enable_conda) {
        exit 1, "Conda environments cannot be used when using the Cell Ranger tool. Please use docker or singularity containers."
    }

    container "luslab/multiomic-cellranger_atac:base-2.0.0"

    input:
    path fasta
    path gtf
    path config
    val reference_name

    output:
    path "${reference_name}", emit: reference
    path "versions.yml"     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    cellranger-atac \\
        mkref \\
        --config=${config}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellranger: \$(echo \$( cellranger --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """
}