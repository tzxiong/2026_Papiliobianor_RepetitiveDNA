#!/bin/bash
#SBATCH -J TEMan
#SBATCH -n 8                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 7-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=30gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o TEMan_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e TEMan_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

source ~/.bashrc
conda activate EnvPy3.12

# extract the consensus sequence from RM2

pfamdb="/local/storage/tx84/Software-large/Databases/Pfam_db"

dir_TE_MANUAL_bin="/home/tx84/Script/S.TE-MANUAL/bin"

fam_name=$1 ## e.g., "rnd-5_family-1187#LTR/Gypsy"
fam_curation_number=$2 ## e.g., "0047"
num_seqs_to_retrive=$3 ## e.g., 100

output_folder=/workdir/tx84/Research/2024_LepChromosomes/00.assembly/Papilio_bianor/05.8.1.satellite.earlgrey.r1.manual_curation/1.curated_families/${fam_curation_number}.${fam_name%#*}
RM2_families_online_fa=/workdir/tx84/Research/2024_LepChromosomes/00.assembly/Papilio_bianor/05.8.1.satellite.earlgrey.r1.manual_curation/Papilio_bianor-families.fa.strained.clstrd.fa

genome_fa=/workdir/tx84/Research/2024_LepChromosomes/00.assembly/Papilio_bianor/04.0.final_assembly/final_assembly.Papilio_bianor.fa

mkdir -p ${output_folder}

cd ${output_folder}

echo ${fam_name} | seqtk subseq ${RM2_families_online_fa} - > ${output_folder}/${fam_name%#*}.query_seed.fa

dotmatcher -threshold 50 -asequence ${fam_name%#*}.query_seed.fa -bsequence ${fam_name%#*}.query_seed.fa -graph png -windowsize 10 -goutfile ${fam_name%#*}.query_seed.dotplot.plus.png

dotmatcher -threshold 50 -asequence ${fam_name%#*}.query_seed.fa -sreverse2 -bsequence ${fam_name%#*}.query_seed.fa -graph png -windowsize 10 -goutfile ${fam_name%#*}.query_seed.dotplot.minus.png

${dir_TE_MANUAL_bin}/make_fasta_from_blast.sh ${genome_fa} ${fam_name%#*}.query_seed.fa 0 2000 # the last number is the padding length on either side

${dir_TE_MANUAL_bin}/ready_for_MSA.sh ${fam_name%#*}.query_seed.fa.blast.bed.fa ${num_seqs_to_retrive} 0 # first num: total subseqs, second num: those selected from the longest alignment

mafft --reorder --thread -1 ${fam_name%#*}.query_seed.fa.blast.bed.fa.rdmSubset.fa > ${fam_name%#*}.maf.fa

trimal -in ${fam_name%#*}.maf.fa -out ${fam_name%#*}.maf.gap_trimmed.fa -gt 0.1 # num: minimum insertion freq to keep gaps

cons -sequence ${fam_name%#*}.maf.gap_trimmed.fa -plurality 0.25 -outseq ${fam_name%#*}.maf.gap_trimmed.consensus.fa

dotmatcher -threshold 50 -asequence ${fam_name%#*}.maf.gap_trimmed.consensus.fa -bsequence ${fam_name%#*}.maf.gap_trimmed.consensus.fa -graph png -windowsize 10 -goutfile ${fam_name%#*}.maf.gap_trimmed.consensus.dotplot.plus.png

dotmatcher -threshold 50 -asequence ${fam_name%#*}.maf.gap_trimmed.consensus.fa -sreverse2 -bsequence ${fam_name%#*}.maf.gap_trimmed.consensus.fa -graph png -windowsize 10 -goutfile ${fam_name%#*}.maf.gap_trimmed.consensus.dotplot.minus.png

getorf -sequence ${fam_name%#*}.maf.gap_trimmed.consensus.fa -outseq ${fam_name%#*}.maf.gap_trimmed.consensus.orf.fa -minsize 300

pfam_scan.pl -fasta ${fam_name%#*}.maf.gap_trimmed.consensus.orf.fa -dir $pfamdb > ${fam_name%#*}.maf.gap_trimmed.consensus.orf.pfam.txt

## dotmatcher -threshold 50 -asequence -bsequence -graph png -windowsize 10
