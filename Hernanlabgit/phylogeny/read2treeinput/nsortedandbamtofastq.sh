
#!/bin/bash -l

#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=5:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#variables
samplename=${1}
refPs=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_Ps/Pseudomonas.OTU5_ref.fasta


#for 7/37
##generate input files of pseudomonas fastq
#Sort the BAM file by chromosome and position using samtools
#samtools sort -n -o /SAN/ugi/plant_genom/jiajucui/read2treeinput/nsortedbam/${samplename}_removalAt_mapped_to_ps.nsorted.q20.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/37HBsamples/${samplename}.mapped_to_Pseudomonas.dd.q20.bam
#samtools fastq /SAN/ugi/plant_genom/jiajucui/read2treeinput/nsortedbam/${samplename}_removalAt_mapped_to_ps.nsorted.q20.bam > /SAN/ugi/plant_genom/jiajucui/read2treeinput/fastq/${samplename}_pseudomonas.fastq.gz

#samtools fastq /SAN/ugi/plant_genom/jiajucui/read2treeinput/nsortedbam/${samplename}_removalAt_mapped_to_ps.nsorted.q20.bam -1 /SAN/ugi/plant_genom/jiajucui/read2treeinput/fastq/${samplename}_R1pseudomonas.fastq.gz -2 /SAN/ugi/plant_genom/jiajucui/read2treeinput/fastq/${samplename}_R2pseudomonas.fastq.gz

##generate input files of pseudomonas fastq
##10/143
#Sort the BAM file by chromosome and position using samtools

#samtools sort -n -o /SAN/ugi/plant_genom/jiajucui/read2treeinput/nsortedbam/${samplename}_removalAt_mapped_to_ps.nsorted.q20.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam

samtools fastq /SAN/ugi/plant_genom/jiajucui/read2treeinput/nsortedbam/${samplename}_removalAt_mapped_to_ps.nsorted.q20.bam > /SAN/ugi/plant_genom/jiajucui/read2treeinput/fastq/h${samplename}_pseudomonas.fastq.gz
