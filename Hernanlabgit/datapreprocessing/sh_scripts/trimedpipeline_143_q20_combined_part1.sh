#!/bin/bash -l

#$ -l tmem=10G
#$ -l h_vmem=10G
#$ -l h_rt=24:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#variables
i=${1}
samplename=$(cat /SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/new_sampleindex.txt | sed -n $i'p' | awk '{print $2}')
echo "${samplename}:" >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
refAt=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_At/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
refPs=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_Ps/Pseudomonas.OTU5_ref.fasta
r1o=/SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/${samplename}.R1.fastq.gz
r2o=/SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/${samplename}.R2.fastq.gz

source ~/miniconda3/bin/activate dataprepython3.10
#collapse_At.sam is from collapsed sai
#r1r2_At.sam is merged from r1.sai and r2.sai
#combined_At.sam is combined from the above two sam files


#collapse:
#trim and merge
AdapterRemoval --file1 ${r1o} --file2 ${r2o} --basename 2_trimmed_merged/trim143/${samplename} --collapse --gzip --threads 2 &&
echo 'trim and merge done' &&
#generate sai
bwa aln -t 2 -l 1024 -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed.sai ${refAt} /SAN/ugi/plant_genom/jiajucui/2_trimmed_merged/trim143/${samplename}.collapsed.gz &&
echo 'bwa aln done' &&
#generate the sam files from collapsed sai
bwa samse -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.sam ${refAt} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed.sai /SAN/ugi/plant_genom/jiajucui/2_trimmed_merged/trim143/${samplename}.collapsed.gz &&
echo 'collapsed bwa samse done' &&
#create a compressed BAM file using samtools
samtools view -b -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.sam
#Sort the BAM file by chromosome and position using samtools
samtools sort -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.bam
#for restore
rm /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.sam &&
echo 'rm collpased.sam' &&

#r1 and r2 first aln separetely and then merge as r1r2bam
#trim files were given by adapterremoval previously names as pair1.truncated.gz and 2. When try single-end mode, adapterremoval give 1.CAN_1994a_S53.truncated.gz for r1 with size 298mb. with paired-end mode, give pair1.truncated.gz wtih size 238mb. I guess we should use paired mode as we need to merge them later.
#ref:https://adapterremoval.readthedocs.io/en/stable/examples.html#trimming-paired-end-reads
#This command generates the files output_paired.pair1.truncated and output_paired.pair2.truncated, which contain trimmed pairs of reads which were not collapsed, output_paired.singleton.truncated containing reads where one mate was discarded, output_paired.collapsed containing merged reads, and output_paired.collapsed.truncated containing merged reads that have been trimmed due to the --trimns or --trimqualities options. 

r1=/SAN/ugi/plant_genom/jiajucui/2_trimmed_merged/trim143/${samplename}.pair1.truncated.gz
r2=/SAN/ugi/plant_genom/jiajucui/2_trimmed_merged/trim143/${samplename}.pair2.truncated.gz

bwa aln -t 2 -l 1024 -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1.truncated.sai ${refAt} ${r1} &&
echo 'bwa aln r1 done' &&
bwa aln -t 2 -l 1024 -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r2.truncated.sai ${refAt} ${r2} &&
echo 'bwa aln r2 done' &&
# Convert  reads into a standard alignment format (SAM)
bwa sampe -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.sam ${refAt} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1.truncated.sai /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r2.truncated.sai ${r1} ${r2} &&
echo 'bwa sampe done' &&
#create a compressed BAM file using samtools
samtools view -b -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.sam
#sort the BAM file by chromosome and position using samtools
samtools sort -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.bam &&
echo 'samtobam and sort done for two' &&

#for restore
rm /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.sam &&
echo 'rm r1r2.sam' &&


#generate the index

samtools index /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.sorted.bam

samtools index /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.sorted.bam

echo 'part1 done'
