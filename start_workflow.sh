#!/bin/bash

source ./config.sh
source ./functions2.sh

if [[ ! -d "$FASTA_DIR" ]]; then
    echo "$FASTA_DIR does not exist. Edit your config.sh file and make sure FASTA_DIR is set to the directory containing your fasta reads."
    exit 1
fi

if [[ ! -d "$BT2_INDEX" ]]; then
    echo "$BT2_INDEX does not exist. You must declare where the Bowtie2 index files are located. Edit config.sh file before you continue. Job terminated."
    exit 1
fi

if [[ ! -d "$BT2_OUT_DIR" ]]; then
    echo "$BT2_OUT_DIR created for clean reads."
    mkdir -p "$BT2_OUT_DIR"
    
if [[ ! -d "$STDOUT_DIR" ]]; then
    echo "$STDOUT_DIR created for standard out."
    mkdir -p "$STDOUT_DIR"
fi

export CWD=$(cd $(dirname "$0") && pwd)
export STEP_SIZE=1

echo "Finding FASTA files in \"$FASTA_DIR\""
export FASTA_LIST=$(mktemp)
find $FASTA_DIR -type f -name \*.fasta > $FASTA_LIST
echo "FASTA files to be processed:" `cat -n $FASTA_LIST`
NUM_FILES=$(lc $FASTA_LIST)

echo "$NUM_FILES"

JOBS_ARG=""
if [[ $NUM_FILES -gt 1 ]]; then
  JOBS_ARG="-J 1-$NUM_FILES"
  if [[ $STEP_SIZE -gt 1 ]]; then
    $JOBS_ARG="$JOBS_ARG:$STEP_SIZE"
  fi
fi

while read FASTA; do
    export FASTA="$FASTA"

    JOB_ID1=$(qsub $JOBS_ARGS -v CWD,FASTA,SCRIPT_DIR,BT2_OUT_DIR,BT2_INDEX,INDEX_BASE,FASTA_LIST,FASTA_DIR,STEP_SIZE -N Bowtie2 -j oe -o "$STDOUT_DIR" $SCRIPT_DIR/bt2_align.sh)

done < $FASTA_LIST

JOB_ID2=$(qsub -v FASTA_DIR,SCRIPT_DIR,BT2_OUT_DIR,NUM_THREAD,MIN_LEN,CON_OUT -N Megahit -W depend=afterok:$JOB_ID1 -j oe -o "$STDOUT_DIR" $SCRIPT_DIR/run_assembly.sh)

