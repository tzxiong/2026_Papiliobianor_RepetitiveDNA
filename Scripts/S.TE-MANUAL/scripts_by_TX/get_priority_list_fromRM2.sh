#!/bin/bash
#SBATCH -J priority
#SBATCH -n 1                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 3-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=8gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o priority_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e priority_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

source ~/.bashrc

conda activate EnvPy3.12

work_dir=$1
dir_RM2_output_families_fa=$2
dir_genome_fa=$3
dir_Pfam_db=$4
dir_TE_MANUAL_SCRIPTS_FOLDER=$5 ## where ${dir}/bin can be found


cd ${work_dir}

~/Script/S.TE-MANUAL/bin/generate_priority_list_from_RM2.sh ${dir_RM2_output_families_fa} ${dir_genome_fa} ${dir_Pfam_db} ${dir_TE_MANUAL_SCRIPTS_FOLDER}