#$ -l tmem=5G
#$ -l h_vmem=5G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N s2023_37HB
#$ -t 1-35
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"
#2 African samples should be submitted with another file (to set different raw fastq path)
/SAN/ugi/plant_genom/jiajucui/datapreprocessing/sh_scripts/2023final_37_q20.sh $SGE_TASK_ID
