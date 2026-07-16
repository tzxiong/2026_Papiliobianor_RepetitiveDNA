#!/bin/bash
#SBATCH -J classifyTE
#SBATCH -n 80                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 14-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=100Gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o classifyTE_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e classifyTE_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

dir_work=$1

cd ${dir_work}

dir_lib_fasta=$2 #fasta file to classify

source ~/.bashrc

conda activate EnvEarlgrey

RepeatClassifier -consensi ${dir_lib_fasta} -threads 80