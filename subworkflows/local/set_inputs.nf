import groovy.transform.Synchronized

include { UNTAR } from '../../modules/nf-core/modules/untar/main.nf'

workflow SET_INPUTS {
    take: file_path
    main:

        // Check if any inputs are passed as tar.gz and untar as required
        Channel
            .fromPath( file_path )
            .splitCsv(header:true)
            .map { row -> ProcessRow(row) }
            .branch{
            tar: it[1] =~ /.tar.gz/
            fastq: true
            }
            .set { ch_inputs }

        // Select files to untar
        ch_inputs
            .tar
            .map{it[1]}
            .set{ch_untar}

        UNTAR(ch_untar)
            .untar
            .map{[it.getSimpleName(), it]}
            .set{ch_untar}

        // Join channel and metadata using matching getSimpleName key
        ch_inputs
            .tar
            .map{[it[1].getSimpleName(), it[0]]}
            .join(ch_untar)
            .map{[it[1], it[2]]}
            .concat(ch_inputs.fastq)
            .set{ch_inputs}

        // Group channels by meta
        ch_inputs
            .groupTuple(by: 0)
            .map{[it[0], it[1].flatten()]}
            .set{ch_inputs}

        // Branch inputs based on data type
        ch_inputs
            .branch {
                RNA: it[0].data_type == 'RNA'
                ATAC: it[0].data_type == 'ATAC'
                }
            .set{ch_inputs}

        emit:
        rna = ch_inputs.RNA
        atac = ch_inputs.ATAC
}



def ProcessRow(LinkedHashMap row, String glob='.*fastq.gz') {
    def meta = [:]
    meta.id             = row.sample_id
    meta.gem            = row.sample_name
    meta.sample_name    = row.sample_name
    meta.samples        = [row.sample_id]
    meta.data_type      = row.data_type

    for (Map.Entry<String, ArrayList<String>> entry : row.entrySet()) {
        String key = entry.getKey();
        String value = entry.getValue();
        if(key != "sample_id" && key != "sample_name" && key != "data_type" && key != "data") {
            meta.put(key, value)
        }
    }

    data = file(row.data, checkIfExists: true)

    // List files
    if (!(data instanceof List) && data.isDirectory()){
        data = data.listFiles()
    }

    // Filter files not matching glob
    def files = []
    for(def file:data){
        if(file.toString().matches(glob)){
            files.add(file)
        }
    }

    def array = [ meta, files]
    return array
}