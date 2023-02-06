#!/bin/bash -l

#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#variables
i=${1}
samplename=$(cat new_sampleindex.txt | sed -n $i'p' | awk '{print $2}')
trimedandmerged=$(zless /SAN/ugi/plant_genom/jiajucui/2_trimmed_merged/${samplename}.collapsed.gz | grep -c '+')
allreadsfq=$(zless /SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/${samplename}.R1.fastq.gz | grep -c '+')
res4=`echo "scale=5; $trimedandmerged/$allreadsfq" | bc`
echo $samplename $trimedandmerged $allreadsfq 0$res4
echo $samplename $trimedandmerged $allreadsfq 0$res4 >> /SAN/ugi/plant_genom/jiajucui/tmreads.txt
