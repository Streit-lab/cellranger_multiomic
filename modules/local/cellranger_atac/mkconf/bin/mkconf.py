#!/usr/local/bin/python

import sys
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--organism", type = str, help='(Optional; string) Name of the organism. This is displayed in the web summary but is otherwise not used in the analysis.', default=None)
parser.add_argument("--genome", type = str, help='(Required; list of strings) name(s) of the genome(s) that comprise the organism. Note: Cell Ranger ATAC only supports single-species references so this list should be of length 1. The reference package is constructed in the current working directory where the directory name is the name of the genome. i.e. GRCh38')
parser.add_argument("--fasta", type = str, help='(Required; path) path(s) to the assembly fasta file(s) for each genome in uncompressed FASTA format. Note: Cell Ranger ATAC only supports single-species references so this list should be of length 1.')
parser.add_argument("--gtf", type = str, help='(Required; path) path(s) to the gene annotation GTF file(s) for each genome in GTF format. Note: Cell Ranger ATAC only supports single-species references so this list should be of length 1.')
parser.add_argument("--non_nuclear_contigs", type = str, help='(Optional; space separated list of strings) name(s) of contig(s) that do not have any chromatin structure, for example, mitochondria or plastids. For the GRCh38 assembly this would be: chrM chrZ. These contigs are excluded from peak calling since the entire contig will be "open" due to a lack of chromatin structure.', nargs='+')
parser.add_argument("--input_motifs", type = str, help='(Optional; path) path to file containing transcription factor motifs in JASPAR format ("/path/to/jaspar/motifs.pfm"). Note: the any spaces in the header name are converted to a single underscore. For ease of use in Loupe we recommend using a header that begins with a human-readable name rather than a motif identifier.')


args = parser.parse_args()

cfig = '{\n}'

if args.organism:
    cfig = cfig.replace('}', ('  organism: "'+args.organism+'"\n}'))

cfig = cfig.replace('}', ('  genome: ["'+args.genome+'"]\n}'))
# cfig = cfig.replace('}',('  genome: ["REFERENCE"]\n}'))
cfig = cfig.replace('}',('  input_fasta: ["'+args.fasta+'"]\n}'))
cfig = cfig.replace('}',('  input_gtf: ["'+args.gtf+'"]\n}'))


if args.non_nuclear_contigs:
    cfig = cfig.replace('}', ('  non_nuclear_contigs: ['+(', '.join('"' + item + '"' for item in args.non_nuclear_contigs))+']\n}'))

if args.input_motifs:
    cfig = cfig.replace('}', ('  input_motifs: "'+args.input_motifs+'"\n}'))

output = open("cellranger_atac.config", "w")
output.write(cfig)
output.close()


