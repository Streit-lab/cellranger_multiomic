#!/usr/bin/env nextflow
/*
========================================================================================
    streitlab/cellranger_multiomic
========================================================================================
*/

nextflow.enable.dsl = 2

/*
========================================================================================
    GENOME PARAMETER VALUES
========================================================================================
*/

params.fasta     = WorkflowMain.getGenomeAttribute(params, 'fasta')
params.gtf       = WorkflowMain.getGenomeAttribute(params, 'gtf')

/*
========================================================================================
    NAMED WORKFLOW FOR PIPELINE
========================================================================================
*/

include { CELLRANGER_MULTIOMIC } from './workflows/cellranger_multiomic'

workflow LUSLAB_CELLRANGER_MULTIOMIC {
    CELLRANGER_MULTIOMIC ()
}

/*
========================================================================================
    THE END
========================================================================================
*/
