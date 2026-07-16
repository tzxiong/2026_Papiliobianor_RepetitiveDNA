#!/bin/bash
#SBATCH -J SRF
#SBATCH -n 4                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 3-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=40gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o SRF_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e SRF_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent


## working directory

dir_work=$1
ref_file=$2
kmer_size=$3
lower_freq_limit=$4

## command

cd ${dir_work}

mkdir -p tmp_dir

kmc -fm -k${kmer_size} -t4 -ci${lower_freq_limit} -cs1000000 ${ref_file} count.kmc tmp_dir

kmc_dump count.kmc count.txt

srf -l 10 -p prefix count.txt > srf.fa

# map ref to repeat contigs
srfutils.js enlong srf.fa > srf.enlong.fa
minimap2 -c -N1000000 -f1000 -r100,100 -t4 srf.enlong.fa ${ref_file} > srf.paf

# map repeat contigis to repeat contigs
minimap2 -c -N1000 <(srfutils.js enlong -d srf.fa) srf.fa > srf.self.paf

# # map ref to adjusted repeat contigs
# srfutils.js enlong srf.adj.fa > srf.adj.enlong.fa
# minimap2 -c -N10000000 -f1000 -r100,100 -t4 srf.adj.enlong.fa ${ref_file} > srf.adj.paf

# # generate non-redundant mapping regions
srfutils.js paf2bed -l 1 -c 0.01 -d 0.01 srf.paf > srf.bed

# # estimate redundance
srfutils.js bed2abun srf.bed > srf.len

# sort alignment file
sort -k1,1 -k3,3n -k4,4n srf.paf > srf.sorted.paf

