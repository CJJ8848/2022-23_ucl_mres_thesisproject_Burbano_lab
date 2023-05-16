#$ -l tmem=5G
#$ -l h_vmem=5G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N s2023_2HB
#$ -t 36-37
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"

/SAN/ugi/plant_genom/jiajucui/datapreprocessing/sh_scripts/2023_2Africans_q20.sh $SGE_TASK_ID
