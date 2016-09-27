#!/bin/bash

#Establish current working directory
export CWD=$PWD

#Directory where scripts are located
export SCRIPT_DIR="$CWD/scripts"

#Directory containing FASTA/FASTQ files contaminated with human reads
export FASTA_DIR="$CWD/fasta"

#Directory AND basename of Bowtie2 index files
export BT2_INDEX="rsgrps/bh_class/bt2_index"
export INDEX_BASE="human_index"

#Directory to place UNMAPPED reads 
export BT2_OUT_DIR="$CWD/clean_reads"

#Directory to place contigs assembled by Megahit
export CON_OUT="$CWD/assembly2"

#Minimum contig length and number of CPU threads
export MIN_LEN="1000"
export NUM_THREAD="4"

#Standard Error/Out Directory 
export STDERR_DIR="$CWD/std-err"
export STDOUT_DIR="$CWD/std-out"

