/*
========================================================================================
    VALIDATE INPUTS
========================================================================================
*/

def valid_params = [
    aligners: ['cellranger'],
    data_type: ['rna', 'atac', 'multiome']
]

// Create summary input parameters map for reporting
def summary_params = NfcoreSchema.paramsSummaryMap(workflow, params)

// Validate input parameters in specialised library
WorkflowScmultiomic.initialise(params, log, valid_params)

// Check input path parameters to see if the files exist if they have been specified
checkPathParamList = [
    params.input,
    params.sample_sheet,
    params.fasta,
    params.gtf
]
for (param in checkPathParamList) { if (param) { file(param, checkIfExists: true) } }

// Check mandatory parameters that cannot be checked in the groovy lib as we want a channel for them
if (params.sample_sheet) { ch_sample_sheet = file(params.sample_sheet) } else { exit 1, "Input samplesheet not specified!" }

// // Save AWS IGenomes file containing annotation version
// def anno_readme = params.genomes[ params.genome ]?.readme
// if (anno_readme && file(anno_readme).exists()) {
//     file("${params.outdir}/genome/").mkdirs()
//     file(anno_readme).copyTo("${params.outdir}/genome/")
// }

// Stage dummy file to be used as an optional input where required
ch_dummy_file = file("$projectDir/assets/dummy_file.txt", checkIfExists: true)

// Check alignment parameters
def prepare_tool_indices  = []
prepare_tool_indices << params.aligner
prepare_tool_indices << params.data_type

/*
========================================================================================
    CONFIG FILES
========================================================================================
*/

/*
========================================================================================
    RESOLVE FLOW SWITCHING
========================================================================================
*/

/*
========================================================================================
    INIALISE PARAMETERS AND OPTIONS
========================================================================================
*/

/*
========================================================================================
    IMPORT LOCAL MODULES/SUBWORKFLOWS
========================================================================================
*/

//
// MODULE: Loaded from modules/local/
//

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//

include { PREPARE_GENOME                            } from '../subworkflows/local/prepare_genome'
include { SET_INPUTS                                } from '../subworkflows/local/set_inputs.nf'
include { CELLRANGER_COUNT as CELLRANGER_RNA_COUNT  } from '../modules/nf-core/modules/cellranger/count/main.nf'
include { CELLRANGER_ATAC_COUNT                     } from '../modules/local/cellranger_atac/count/main.nf'

/*
========================================================================================
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
========================================================================================
*/


/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

workflow CELLRANGER_MULTIOMIC {
    ch_versions = Channel.empty()

    //
    // SUBWORKFLOW: Prepare genome references
    //
    PREPARE_GENOME (
        prepare_tool_indices
    )
    ch_versions = ch_versions.mix(PREPARE_GENOME.out.versions)

    //
    // SUBWORKFLOW: Read in samplesheet, validate and stage input files
    //
    SET_INPUTS (
        ch_sample_sheet
    )

    CELLRANGER_RNA_COUNT ( SET_INPUTS.out.rna, PREPARE_GENOME.out.cellranger_rna_reference )
    CELLRANGER_ATAC_COUNT ( SET_INPUTS.out.atac, PREPARE_GENOME.out.cellranger_atac_reference )
}