#!/bin/bash
#SBATCH -J balance
#SBATCH -n 4                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 7-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=20gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o balance_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e balance_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

## working directory (the directory of all relevant samtools_region.*.txt files)

source ~/.bashrc

conda activate EnvCooler

dir_work=$1
path_to_mcool_file=$2 # full path

cd ${dir_work}

cooler_list=$(cooler ls ${path_to_mcool_file})

parallel -j1 "cooler balance --convergence-policy store_nan --nproc 4 {}" ::: ${cooler_list}

