#!/bin/bash
#SBATCH -J cdhit
#SBATCH -n 1                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 3-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=8gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o cdhit_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e cdhit_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

source ~/.bashrc

conda activate EnvPy3.12

work_dir=$1
input_families_fa=$2

cd ${work_dir}

cd-hit-est -i ${input_families_fa} -o ${input_families_fa%.fa}.cdhit.fa  -d 0 -aS 0.8 -c 0.8 -G 0 -g 1 -b 500 # 80-80-80 rule

# show multi-element clusters

awk '/^>/ { if (header && count > 1) printf "%s", buf; header = $0; buf = $0 "\n"; count = 0; next } { buf = buf $0 "\n"; count++ } END { if (header && count > 1) printf "%s", buf }' ${input_families_fa%.fa}.cdhit.fa.clstr > ${input_families_fa%.fa}.cdhit.fa.clstr.multiples