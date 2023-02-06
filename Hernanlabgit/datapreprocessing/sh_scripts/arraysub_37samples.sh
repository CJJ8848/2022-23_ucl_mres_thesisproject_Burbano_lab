#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N jan27_7samples
#$ -t 1-7
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"

./pipeline_37_7_2023.1.27.sh $SGE_TASK_ID
