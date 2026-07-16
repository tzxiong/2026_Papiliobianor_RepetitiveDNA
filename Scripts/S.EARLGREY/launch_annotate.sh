#!/bin/bash
#SBATCH -J erlgry
#SBATCH -n 100                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 14-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=300Gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o earlgrey_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e earlgrey_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

dir_work=$1

cd ${dir_work}

dir_fasta=$2 # genome fasta
species_name=$3
dir_out=$4
premasking_library_fa=$5 # optional, only if using the -l flag

source ~/.bashrc

conda activate EnvEarlgrey

earlGreyAnnotationOnly -g ${dir_fasta} -s ${species_name} -o ${dir_out} -t 100 -m yes -l ${premasking_library_fa}