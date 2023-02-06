output=/SAN/ugi/plant_genom/jiajucui/phylogeny/r2toutputs/r2toutputmultiple25ref4samples
markers=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/marker_genes/
pathtofq=/SAN/ugi/plant_genom/jiajucui/phylogeny/read2treeinput/fastq
#multiple
#read2tree --standalone_path ${markers} --output_path ${output} --reference
read2tree --standalone_path ${markers} --output_path ${output} --reads ${pathtofq}/rename9.p20.G9.R1.fastq.gz ${pathtofq}/rename9.p20.G9.R2.fastq.gz
#read2tree --standalone_path ${markers} --output_path ${output} --reads ${pathtofq}/HB0828_pseudomonas.fastq.gz
#read2tree --standalone_path ${markers} --output_path ${output} --reads ${pathtofq}/h30.ESP_1983b_pseudomonas.fastq.gz
#read2tree --standalone_path ${markers} --output_path ${output} --reads ${pathtofq}/HB0863_pseudomonas.fastq.gz
read2tree --standalone_path ${markers} --output_path ${output} --merge_all_mappings --tree > ${output}/multiple4samples.log
