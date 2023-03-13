#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { UNTAR } from '../../../../modules/nf-core/modules/untar/main.nf'
include { CELLRANGER_ATAC_MKCONF } from '../../../../modules/local/cellranger_atac/mkconf/main.nf'
include { CELLRANGER_MKGTF } from '../../../../modules/nf-core/modules/cellranger/mkgtf/main.nf'
include { CELLRANGER_ATAC_MKREF } from '../../../../modules/local/cellranger_atac/mkref/main.nf'
include { CELLRANGER_ATAC_COUNT } from '../../../../modules/local/cellranger_atac/count/main.nf'
include { GUNZIP as GUNZIP_GENOME; GUNZIP as GUNZIP_GTF } from '../../../../modules/local/gunzip/main.nf'

workflow test_cellranger_atac_count {

    UNTAR( params.test_data['homo_sapiens']['illumina']['test_10x_atac_fastq_gz'] )
        .untar
        .map { [[ id:'sub', single_end:true, strandedness:'forward', gem: '123', samples: ["sub_atac_pbmc_500_v1"]], it] }
        .set{ ch_input }
        
    fasta = GUNZIP_GENOME( file(params.test_data['homo_sapiens']['genome']['genome_fasta_gz'], checkIfExists: true) ).gunzip
    gtf = GUNZIP_GTF( file(params.test_data['homo_sapiens']['genome']['genome_gtf_gz'], checkIfExists: true) ).gunzip
    reference_name = "homo_sapiens"

    CELLRANGER_MKGTF ( gtf )
    CELLRANGER_ATAC_MKCONF ( fasta, CELLRANGER_MKGTF.out.gtf, reference_name )
    CELLRANGER_ATAC_MKREF ( fasta, CELLRANGER_MKGTF.out.gtf, CELLRANGER_ATAC_MKCONF.out.config, reference_name )
    CELLRANGER_ATAC_COUNT( ch_input, CELLRANGER_ATAC_MKREF.out.reference )
}