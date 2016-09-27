#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l pvmem=22gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

set -u

cd $FASTA_DIR

FASTA=$(ls ./*.fasta | python -c 'import sys; print ",".join([x.strip() for x in sys.stdin.readlines()])')

megahit -r $FASTA --min-contig-len $MIN_LEN -t $NUM_THREAD -o $CON_OUT
