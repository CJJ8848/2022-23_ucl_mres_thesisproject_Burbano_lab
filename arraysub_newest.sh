#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N ROUND2
#$ -t 1-15
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"

./pipeline_newest.sh $SGE_TASK_ID
