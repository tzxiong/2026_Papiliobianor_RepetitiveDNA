#!/bin/bash
#SBATCH -J TEMan
#SBATCH -n 16                # Number of cores
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

output_folder="/local/workdir/tx84/Research/2024_LepChromosomes/00.assembly/Papilio_bianor/05.8.1.satellite.earlgrey.r1.manual_curation/1.curated_families/0147.rnd-5_family-264/rnd-5_family-264.maf.gap_trimmed.part_01.seed"

seed_fa="rnd-5_family-264.maf.gap_trimmed.part_01.seed.fa"

fam_name=${seed_fa%.fa}

genome_fa=/workdir/tx84/Research/2024_LepChromosomes/00.assembly/Papilio_bianor/04.0.final_assembly/final_assembly.Papilio_bianor.fa

mkdir -p ${output_folder}

cd ${output_folder}

dotmatcher -threshold 50 -asequence ${seed_fa%.fa}.fa -bsequence ${seed_fa%.fa}.fa -graph png -windowsize 10 -goutfile ${seed_fa%.fa}.dotplot.plus.png

dotmatcher -threshold 50 -asequence ${seed_fa%.fa}.fa -sreverse2 -bsequence ${seed_fa%.fa}.fa -graph png -windowsize 10 -goutfile ${seed_fa%.fa}.dotplot.minus.png

${dir_TE_MANUAL_bin}/make_fasta_from_blast.sh ${genome_fa} ${seed_fa%.fa}.fa 0 4000 # the last number is the padding length on either side

${dir_TE_MANUAL_bin}/ready_for_MSA.sh ${seed_fa%.fa}.fa.blast.bed.fa 7 0 # first num: total subseqs, second num: those selected from the longest alignment

mafft --reorder --thread -1 ${seed_fa%.fa}.fa.blast.bed.fa.rdmSubset.fa > ${seed_fa%.fa}.maf.fa

trimal -in ${seed_fa%.fa}.maf.fa -out ${seed_fa%.fa}.maf.gap_trimmed.fa -gt 0.1 # num: minimum insertion freq to keep gaps

cons -sequence ${seed_fa%.fa}.maf.gap_trimmed.fa -plurality 0.25 -outseq ${seed_fa%.fa}.maf.gap_trimmed.consensus.fa

dotmatcher -threshold 50 -asequence ${seed_fa%.fa}.maf.gap_trimmed.consensus.fa -bsequence ${seed_fa%.fa}.maf.gap_trimmed.consensus.fa -graph png -windowsize 10 -goutfile ${seed_fa%.fa}.maf.gap_trimmed.consensus.dotplot.plus.png

dotmatcher -threshold 50 -asequence ${seed_fa%.fa}.maf.gap_trimmed.consensus.fa -sreverse2 -bsequence ${seed_fa%.fa}.maf.gap_trimmed.consensus.fa -graph png -windowsize 10 -goutfile ${seed_fa%.fa}.maf.gap_trimmed.consensus.dotplot.minus.png

getorf -sequence ${seed_fa%.fa}.maf.gap_trimmed.consensus.fa -outseq ${seed_fa%.fa}.maf.gap_trimmed.consensus.orf.fa -minsize 300

pfam_scan.pl -fasta ${seed_fa%.fa}.maf.gap_trimmed.consensus.orf.fa -dir $pfamdb > ${seed_fa%.fa}.maf.gap_trimmed.consensus.orf.pfam.txt

## dotmatcher -threshold 50 -asequence -bsequence -graph png -windowsize 10
