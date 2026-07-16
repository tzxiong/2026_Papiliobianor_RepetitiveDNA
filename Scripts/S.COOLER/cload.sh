#!/bin/bash
#SBATCH -J cload
#SBATCH -n 4                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 7-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=20gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o cload_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e cload_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

## working directory (the directory of all relevant samtools_region.*.txt files)

source ~/.bashrc

conda activate EnvCooler

dir_work=$1
path_to_chromsizes_file=$2 # full path
bin_width=$3 # e.g., 10000
pairs_files_list=$4
output_prefix=$5

cd ${dir_work}

ls *.bedpe > pairs_files.list

parallel -j4 "cooler cload pairs --chrom1 1 --chrom2 4 --pos1 2 --pos2 5 --input-copy-status unique --field count=7:dtype=float ${path_to_chromsizes_file}:${bin_width} {1} {1}.cool" :::: pairs_files.list

wait

cool_files=$(ls *.cool)

cooler merge ${output_prefix}.cool ${cool_files}

