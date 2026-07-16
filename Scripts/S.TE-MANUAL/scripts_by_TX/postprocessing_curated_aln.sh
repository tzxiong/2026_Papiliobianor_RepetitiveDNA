#!/bin/bash
#SBATCH -J TE_post
#SBATCH -n 1                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 7-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p regular           # Partition to submit to
#SBATCH --mem=20gb           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o TEPost_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e TEPost_%j.err  # File to which STDERR will be written, %j inserts jobid
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=tx84@cornell.edu  #Email to which notifications will be sent

source ~/.bashrc
conda activate EnvEarlgrey

pfamdb="/local/storage/tx84/Software-large/Databases/Pfam_db"

dir_work=$1 # directory to the fasta file
file_curated_aln=$2 #e.g. "rnd-1_family-280.maf.gap_trimmed.part_01.curated_01.fa"

repeat_name=${file_curated_aln%%.*}

cd ${dir_work}


cons -name ${repeat_name} -plurality 0.2 -sequence ${file_curated_aln} -outseq ${file_curated_aln%.fa}.cons.fa

RepeatClassifier -consensi ${file_curated_aln%.fa}.cons.fa

dotmatcher -threshold 50 -asequence ${file_curated_aln%.fa}.cons.fa -bsequence ${file_curated_aln%.fa}.cons.fa -graph png -windowsize 10 -goutfile ${file_curated_aln%.fa}.cons.dotplot.plus.png

dotmatcher -threshold 50 -asequence ${file_curated_aln%.fa}.cons.fa -sreverse2 -bsequence ${file_curated_aln%.fa}.cons.fa -graph png -windowsize 10 -goutfile ${file_curated_aln%.fa}.cons.dotplot.minus.png

getorf -sequence ${file_curated_aln%.fa}.cons.fa -outseq ${file_curated_aln%.fa}.cons.orf.fa -minsize 300

pfam_scan.pl -fasta ${file_curated_aln%.fa}.cons.orf.fa -dir $pfamdb > ${file_curated_aln%.fa}.cons.orf.pfam.txt