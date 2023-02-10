#!/bin/bash -l

#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=20:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#historical
source ~/tools/miniconda3/bin/activate read2tree3.8
i=${1}                                                       
historicalsample=$(cat /SAN/ugi/plant_genom/jiajucui/phylogeny/samplelist/historical.txt | sed -n $i'p')
output=/SAN/ugi/plant_genom/jiajucui/phylogeny/r2toutputs/r2tfinal
markers=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/marker_genes/
pathtofq=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/fastq
#multiple
echo ${historicalsample} | tee -a  ${output}/allsamples.log
read2tree --standalone_path ${markers} --output_path ${output} --reads ${pathtofq}/${historicalsample} | tee -a  ${output}/allsamples.log

