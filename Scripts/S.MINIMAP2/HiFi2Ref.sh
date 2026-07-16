#!/bin/bash
#SBATCH -J hifi2ref
#SBATCH -n 64                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 14-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=128Gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o hifi2ref_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e hifi2ref_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

dir_work=$1
ref=$2
hifi_reads=$3
output_prefix=$4

cd ${dir_work}

minimap2 -ax map-hifi --secondary=no -t 63 ${ref} ${hifi_reads} > ${output_prefix}.sam
