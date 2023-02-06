#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N straincheck
#$ -t 1-143
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"

./q20_straincheck.sh $SGE_TASK_ID

#./newsample_pipeline.sh $SGE_TASK_ID
