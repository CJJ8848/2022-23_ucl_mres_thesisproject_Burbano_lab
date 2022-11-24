#!/bin/bash -l

#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#variables
#HB0729
i=${1}
samplename=$(cat samplename_round2.txt | sed -n $i'p')
echo "${samplename}:" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
refAt=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_At/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
collapsed=/SAN/ugi/plant_genom/Pseudomonas_Phages/raw_fastq/athaliana/${samplename}.combined.collapsed.gz
##for Atheliana questions from the collapsed.gz
bwa aln -t 2 -l 1024 -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.collapsed.sai ${refAt} /SAN/ugi/plant_genom/Pseudomonas_Phages/raw_fastq/athaliana/${samplename}.combined.collapsed.gz &&
echo 'bwa aln done' &&
#Convert  reads into a standard alignment format (SAM)
bwa samse -r @RG\\tID:${samplename}\\tSM:${samplename} -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.collapsed_At.sam ${refAt} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.collapsed.sai /SAN/ugi/plant_genom/Pseudomonas_Phages/raw_fastq/athaliana/${samplename}.combined.collapsed.gz &&
echo 'bwa samse done' &&
samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.collapsed_At.sam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_Atsam_flagstats.log 
echo "q1 What is the percentage of A.theliana DNA?" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
echo "base in total:" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
grep 'in total' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_Atsam_flagstats.log  >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt

#convert mapped reads into bam with map quality score greater than 80 
samtools view -@ 2 -F 4  -q 20 -Sbh -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_mapped_At_q20.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.collapsed_At.sam
#flagstat for q1 What is the percentage of A.theliana DNA?
samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_mapped_At_q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_At_q20_flagstats.log 
echo "base mapped to At (-q20):" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_At_q20_flagstats.log >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt

#q2 What is the percentage of Pseudomonas DNA? after removing mapped reads to A.theliana
#the pure bam files after removing mapped reads to At are availible on the server
#so begin with the filtered ones
samtools view -q 20 /SAN/ugi/plant_genom/Pseudomonas_Phages/bams/${samplename}.mapped_to_Pseudomonas.dd.bam -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.bam
samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_Ps_q20_flagstats.log
#output
echo "q2 What is the percentage of Pseudomonas DNA after removing mapped reads to A.theliana?" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
echo "base mapped to Pseudomonas (-q20) after removing:" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_Ps_q20_flagstats.log >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt

#get the number of base mapped to pseudomonas
#q3 What is the percentage that remains unannotated?
echo 'q3 What is the percentage that remains unannotated?' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?
echo 'q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#coverage
samtools depth -aa  /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.coverage.txt
echo 'pseudomonas bases in total:' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
wc -l /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.coverage.txt | cut -d ' ' -f 1 >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#5941411
echo 'bases with at least 1 read:' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
awk '($3 >= 1) {count++} END {print count}' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.coverage.txt >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#872665
#q5 What is the distribution of edit distances? Distribution of edit distances - Histograms
#echo 'NM:' >> ${samplename}_NM.txt
samtools view /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.bam | awk -F 'NM:i:' '{print $2}' | cut -d 'X' -f 1 | xargs >> /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/NM_readlength/${samplename}_NM.txt
#echo 'length:
samtools view /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.dd.q20.bam | cut -d$'\t' -f 10 | awk '{print length()}' >> /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/NM_readlength/${samplename}_readlength.txt &&
echo 'all calculation done' &&

#bash pipeline_18nov.sh HB0725 > HB0725_testpipe.log 2>&1
#R script to plot
