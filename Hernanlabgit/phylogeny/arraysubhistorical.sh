#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N r2tallhist
#$ -t 1-17
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"

#bash modernallallwith2ref1out_runr2t.sh $SGE_TASK_ID

bash /SAN/ugi/plant_genom/jiajucui/phylogeny/histallwith2ref1out_runr2t.sh $SGE_TASK_ID
