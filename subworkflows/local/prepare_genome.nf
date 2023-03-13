/*
 * Uncompress and prepare reference genome files
*/

include { GUNZIP as GUNZIP_FASTA } from '../../modules/local/gunzip/main'
include { GUNZIP as GUNZIP_GTF   } from '../../modules/local/gunzip/main'
include { GUNZIP as GUNZIP_BED   } from '../../modules/local/gunzip/main'
include { CELLRANGER_MKGTF       } from '../../modules/nf-core/modules/cellranger/mkgtf/main.nf'
include { CELLRANGER_MKREF       } from '../../modules/nf-core/modules/cellranger/mkref/main.nf'
include { CELLRANGER_ATAC_MKCONF } from '../../modules/local/cellranger_atac/mkconf/main.nf'
include { CELLRANGER_ATAC_MKREF  } from '../../modules/local/cellranger_atac/mkref/main.nf'

workflow PREPARE_GENOME {
    take:
    prepare_tool_indices // list: tools to prepare indices for

    main:
    ch_versions = Channel.empty()

    /*
    * Uncompress genome fasta file if required
    */
    if (params.fasta.endsWith(".gz")) {
        ch_fasta    = GUNZIP_FASTA ( params.fasta ).gunzip
        ch_versions = ch_versions.mix(GUNZIP_FASTA.out.versions)
    } else {
        ch_fasta = file(params.fasta)
    }

    /*
    * Uncompress GTF annotation file
    */
    ch_gtf = Channel.empty()
    if (params.gtf.endsWith(".gz")) {
        ch_gtf      = GUNZIP_GTF ( params.gtf ).gunzip
        ch_versions = ch_versions.mix(GUNZIP_GTF.out.versions)
    } else {
        ch_gtf = file(params.gtf)
    }

    ch_atac_reference = Channel.empty()
    ch_rna_reference = Channel.empty()
    if ("cellranger" in prepare_tool_indices) {
        CELLRANGER_MKGTF ( ch_gtf )
        ch_versions = ch_versions.mix(CELLRANGER_MKGTF.out.versions)

        if ("atac" in prepare_tool_indices || "multiome" in prepare_tool_indices) {
            CELLRANGER_ATAC_MKCONF ( ch_fasta, CELLRANGER_MKGTF.out.gtf, params.reference_name )
            ch_atac_reference = CELLRANGER_ATAC_MKREF ( ch_fasta, CELLRANGER_MKGTF.out.gtf, CELLRANGER_ATAC_MKCONF.out.config, params.reference_name ).reference
            ch_versions = ch_versions.mix(CELLRANGER_ATAC_MKREF.out.versions)
        }

        if ("rna" in prepare_tool_indices || "multiome" in prepare_tool_indices) {
            ch_rna_reference = CELLRANGER_MKREF ( ch_fasta, CELLRANGER_MKGTF.out.gtf, params.reference_name ).reference
            ch_versions = ch_versions.mix(CELLRANGER_MKREF.out.versions)
        }
    }

    emit:
    fasta                       = ch_fasta                    // path: genome.fasta
    gtf                         = ch_gtf                      // path: genome.gtf
    cellranger_atac_reference   = ch_atac_reference
    cellranger_rna_reference    = ch_rna_reference

    versions                    = ch_versions                 // channel: [ versions.yml ]
}
