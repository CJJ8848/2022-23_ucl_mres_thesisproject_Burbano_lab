#!/bin/bash -l

#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=20:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#modern
source ~/tools/miniconda3/bin/activate read2tree3.8
#variables                                                     
i=${1}                                                      
modernsample=$(cat /SAN/ugi/plant_genom/jiajucui/phylogeny/samplelist/modern.txt | sed -n $i'p')
output=/SAN/ugi/plant_genom/jiajucui/phylogeny/r2toutputs/r2tfinal
markers=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/marker_genes/
pathtofq=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/fastq
#multiple
echo ${modernsample} | tee -a ${output}/allsamples.log
read2tree --standalone_path ${markers} --output_path ${output} --reads ${pathtofq}/${modernsample}.pair1.truncated.gz ${pathtofq}/${modernsample}.pair2.truncated.gz | tee -a ${output}/allsamples.log
