#!/bin/bash
#SBATCH -J ReOMarker
#SBATCH -n 10               # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 1-00:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p shared,unrestricted           # Partition to submit to
#SBATCH --mem 100gb           # Memory pool for all cores (see also --me$
#SBATCH -o ReOMarker_%j.out  # File to which STDOUT will be written, %j i$
#SBATCH -e ReOMarker_%j.err  # File to which STDERR will be written, %j i$
#SBATCH --mail-type=ALL      # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=txiong@g.harvard.edu  #Email to which notifications will be sent

chromosome=$1
dir_call_data=$2
dir_order_file=$3
dir_output=$4
grandparentPhase=$5
families=$6 #choose from F01-F11 or F12-F16 or F01-F16
recombination=$7 #default in LepMap3 = 0.001
interference=$8 #default in LepMap3 = 0.001, smaller -> more interference

if [ "${families}" == "F01-F11" ];then 
    f="F01 F02 F03 F04 F05 F06 F07 F08 F09 F10 F11"
elif [ "${families}" == "F12-F16" ];then
    f="F12 F13 F14 F15 F16"
else
    f="F01 F02 F03 F04 F05 F06 F07 F08 F09 F10 F11 F12 F13 F14 F15 F16"
fi

echo "working on ${dir_call_data}, chromosome ${chromosome}"
echo "grandparentPhase=${grandparentPhase}"
echo "families=${families}"
echo "recombination1=${recombination}"
echo "interference1=${interference}"
echo "including pseudo grandparents"




module load jdk/20.0.1-fasrc01

# zcat /n/holyscratch01/mallet_lab/txiong/Research/2022_HybridSterility/05_LinkageMap.LepMap3/call_data/data.call.chr.${chromosome}.gz | java -Xmx135G -cp ~/Software/LepMap3/bin/ OrderMarkers2 evaluateOrder=${dir_order_file}/order.chr.${chromosome}.txt data=- recombination2=0 improveOrder=0 outputPhasedData=1 grandparentPhase=1 useMorgan=1 numThreads=15 >${dir_output}/order.eval.grandparentPhase.1.chr.${chromosome}.txt

zcat ${dir_call_data}/data.call.with_pseudoGrandparents.fixedDiff_only.chr.${chromosome}.gz | java -Xmx90G -cp ~/Software/LepMap3/bin/ OrderMarkers2 evaluateOrder=${dir_order_file}/order.with_pseudoGrandparents.fixedDiff_only.chr.${chromosome}.txt data=- recombination2=0 recombination1=${recombination} interference1=${interference} outputPhasedData=1 grandparentPhase=${grandparentPhase} useMorgan=1 numThreads=10 families=${f} >${dir_output}/improve.1.with_pseudoGrandparents.fixedDiff_only.grandparentPhase.${grandparentPhase}.recombination1.${recombination}.interference1.${interference}.${families}.chr.${chromosome}.txt