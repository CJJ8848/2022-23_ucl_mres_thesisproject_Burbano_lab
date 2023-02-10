#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:0:0
#$ -S /bin/bash
#$ -N r2tallmodern
#$ -t 1-85
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -wd /SAN/ugi/plant_genom/jiajucui/

echo "Task id is $SGE_TASK_ID"

bash /SAN/ugi/plant_genom/jiajucui/phylogeny/modernallallwith2ref1out_runr2t.sh $SGE_TASK_ID

#bash histallwith2ref1out_runr2t.sh $SGE_TASK_ID
