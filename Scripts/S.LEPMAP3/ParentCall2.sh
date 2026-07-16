#!/bin/bash
#SBATCH -J PCall
#SBATCH -n 3               # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 3-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem 10gb           # Memory pool for all cores (see also --me$
#SBATCH -o PCall_%j.out  # File to which STDOUT will be written, %j i$
#SBATCH -e PCall_%j.err  # File to which STDERR will be written, %j i$
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

chromosome=$1
dir_vcf=$2
dir_output=$3
pedigree_file=$4

## make sure you have java! (e.g., jdk)

mkdir -p ${dir_output}/call_data
mkdir -p ${dir_output}/order_markers_results
mkdir -p ${dir_output}/order_markers_results/orders
mkdir -p ${dir_output}/call_data/data.call.with_pseudoGrandparents.fixedDiff_only.marker_positions

#### zcat ${dir_vcf}/Joint.scaffold_${chromosome}.snp.filtered2.vcf.gz | java -cp ~/Software/LepMap3/bin/ ParentCall2 data=${pedigree_file} vcfFile=- removeNonInformative=0 ZLimit=2 halfSibs=1 | gzip > ${dir_output}/data.call.retainNonInformative.chr.${chromosome}.gz

# zcat ${dir_vcf}/Joint.scaffold_${chromosome}.snp.filtered.simple_annotation.with_pseudograndparents.fixedDiff_withoutRef.fixedDiff_only.vcf.gz | java -cp ~/Software/LepMap3/bin/ ParentCall2 data=${pedigree_file} vcfFile=- removeNonInformative=1 ZLimit=2 halfSibs=1 | gzip > ${dir_output}/call_data/data.call.with_pseudoGrandparents.fixedDiff_only.chr.${chromosome}.gz

# # create order file

# n_snp=$(zcat ${dir_output}/call_data/data.call.with_pseudoGrandparents.fixedDiff_only.chr.${chromosome}.gz | wc -l - | awk '{print ($1 - 7)}' -)

# for ((i=1;i<=${n_snp};i++)); do
# echo $i >> ${dir_output}/order_markers_results/orders/order.with_pseudoGrandparents.fixedDiff_only.chr.${chromosome}.txt
# done

# create marker positions file

zcat ${dir_output}/call_data/data.call.with_pseudoGrandparents.fixedDiff_only.chr.${chromosome}.gz | awk '{if (NR>7) {print $2}}' >> ${dir_output}/call_data/data.call.with_pseudoGrandparents.fixedDiff_only.marker_positions/chr.${chromosome}.txt