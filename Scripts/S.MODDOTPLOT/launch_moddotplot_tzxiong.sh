#!/bin/bash
#SBATCH -J mdp
#SBATCH -n 1                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 30-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=25gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o mdp_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e mdp_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

## working directory (the directory of all relevant samtools_region.*.txt files)

source ~/.bashrc

conda activate ModDotPlot

dir_work=$1
fasta_file=$2
window_size=$3

## run version in the forked repo: https://github.com/tzxiong/ModDotPlot

# moddotplot static -f ${fasta_file} -w ${window_size} --no-plot --compare-only --output-dir ${dir_work} ## only perform between chrs

moddotplot static -f ${fasta_file} -w ${window_size} --no-plot --compare --output-dir ${dir_work} ## between & within chrs
