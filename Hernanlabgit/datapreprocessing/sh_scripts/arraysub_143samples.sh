#$ -l tmem=10G
#$ -l h_vmem=10G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N trim143
#$ -t 1-143
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"

/SAN/ugi/plant_genom/jiajucui/datapreprocessing/sh_scripts/trimedpipeline_143_q20_combined_all.sh $SGE_TASK_ID

#/SAN/ugi/plant_genom/jiajucui/datapreprocessing/sh_scripts/trimedpipeline_143_q20_combined_part2.sh $SGE_TASK_ID

# mem=10g and time=24
#/SAN/ugi/plant_genom/jiajucui/datapreprocessing/sh_scripts/trimedpipeline_143_q20_combined_part1.sh $SGE_TASK_ID
