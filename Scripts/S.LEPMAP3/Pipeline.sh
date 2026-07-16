#!/bin/bash

chromosome=$1
dir_vcf=/local/storage/tx84/Research/2022_HybridSterility/03.5_call.bcftools_final_assembly/vcfs
dir_output=/local/storage/tx84/Research/2022_HybridSterility/05.5_linkageMap.lepmap3_final_assembly
pedigree_file=/local/storage/tx84/Research/2022_HybridSterility/Family_Info_Finalized_withPseudoGrandParents_transposed.txt

RES=$(sbatch /home/tx84/Script/S.LEPMAP3/ParentCall2.sh ${chromosome} ${dir_vcf} ${dir_output} ${pedigree_file})

sbatch --dependency=afterok:${RES##* } /home/tx84/Script/S.LEPMAP3/OrderMarkers2.sh ${chromosome} ${dir_output}/call_data ${dir_output}/order_markers_results/orders ${dir_output}/order_markers_results 1 F01-F16 0.001 0.001



