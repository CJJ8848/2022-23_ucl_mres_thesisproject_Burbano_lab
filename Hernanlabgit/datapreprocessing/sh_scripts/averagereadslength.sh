
#!/bin/bash

#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
P=${1}

ls ${P} | grep "r1r2_At.sorted.bam" | less > ${P}/r1r2_list.txt

for i in $(cat "${P}/r1r2_list.txt") ; do
samtools view -f66 ${i} | cut -f9 |awk '{print sqrt($0^2)}' | awk '{sum+=$1} END {print "'$i'", sum/NR}' ; 
done > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/insert_size.txt

