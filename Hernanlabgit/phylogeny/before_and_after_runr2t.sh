
conda activate read2tree3.8
#!!!
#shell: first ref
output=/SAN/ugi/plant_genom/jiajucui/phylogeny/r2toutputs/r2tfinal
markers=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/marker_genes/
pathtofq=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/fastq
read2tree --standalone_path ${markers} --output_path ${output} --reference | tee -a ${output}/allsamples.log


#after all merge
output=/SAN/ugi/plant_genom/jiajucui/phylogeny/r2toutputs/r2tfinal
markers=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/marker_genes/
pathtofq=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/fastq

read2tree --standalone_path ${markers} --output_path ${output} --merge_all_mappings --tree | tee -a ${output}/allsamples.log
