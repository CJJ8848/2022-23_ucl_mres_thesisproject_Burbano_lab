#!/bin/bash -l

#$ -l tmem=5G
#$ -l h_vmem=5G
#$ -l h_rt=30:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#variables
i=${1}
samplename=$(cat /SAN/ugi/plant_genom/jiajucui/datapreprocessing/samplenamelists/samplename_37.txt | sed -n $i'p')
echo "${samplename}:" >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
refAt=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_At/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
refPs=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_Ps/Pseudomonas.OTU5_ref.fasta
collapsed=/SAN/ugi/plant_genom/Pseudomonas_Phages/raw_fastq/athaliana/${samplename}.combined.collapsed.gz

source ~/miniconda3/bin/activate dataprepython3.10

##for Atheliana questions from the collapsed.gz
bwa aln -t 2 -l 1024 -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}.collapsed.sai ${refAt} ${collapsed}
#Convert  reads into a standard alignment format (SAM)
bwa samse -r @RG\\tID:${samplename}\\tSM:${samplename} -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}.collapsed_At.sam ${refAt} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}.collapsed.sai ${collapsed}
samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}.collapsed_At.sam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_Atsam_flagstats.log 
echo "q1 What is the percentage of A.theliana DNA?" >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
echo "base in total:" >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
grep 'in total' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_Atsam_flagstats.log  >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt


#convert mapped reads into bam with map quality score greater than 80 
samtools view -@ 2 -F 4  -q 20 -Sbh -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_mapped_At_q20.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}.collapsed_At.sam
##dont rm sam because I didnt creaate a bam for it

#flagstat for q1 What is the percentage of A.theliana DNA?
samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_mapped_At_q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_At_q20_flagstats.log 
echo "base mapped to At (-q20):" >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_At_q20_flagstats.log >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt


#q2 What is the percentage of Pseudomonas DNA? after removing mapped reads to A.theliana

####################
##separate pseudomonas from remains DNA (removal)
samtools view -bf 4 /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}.collapsed_At.sam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_after_removal_mappedAt.bam


##use bwa to realign the unmapped bam file
bwa aln -t 2 -l 1024 ${refPs} -b /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_after_removal_mappedAt.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_realign.sai

bwa samse -r @RG\\tID:${samplename}\\tSM:${samplename} -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_mapped_to_ps.sam ${refPs} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_realign.sai /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/2023_37HB/${samplename}_after_removal_mappedAt.bam
#Keep the mapped reads and create a compressed BAM file using samtools
samtools view -@ 2 -F 4 -Sbh -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_mapped_to_ps.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_mapped_to_ps.sam

#Sort the BAM file by chromosome and position using samtools
samtools sort -@ 2 -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_mapped_to_ps.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_mapped_to_ps.bam

samtools view -q 20 /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_removalAt_mapped_to_ps.sorted.bam -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.bam

samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_Ps_q20_flagstats.log
#output
echo "q2 What is the percentage of Pseudomonas DNA after removing mapped reads to A.theliana?" >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
echo "base mapped to Pseudomonas (-q20) after removing:" >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}_Ps_q20_flagstats.log >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt

#get the number of base mapped to pseudomonas
#q3 What is the percentage that remains unannotated?
echo 'q3 What is the percentage that remains unannotated?' >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
#q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?
echo 'q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?' >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
#coverage
samtools depth -aa  /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.coverage.txt
echo 'pseudomonas bases in total:' >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
wc -l /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.coverage.txt | cut -d ' ' -f 1 >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
#5941411
echo 'bases with at least 1 read:' >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
awk '($3 >= 1) {count++} END {print count}' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.coverage.txt >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
#872665
#q5 What is the distribution of edit distances? Distribution of edit distances - Histograms
#echo 'NM:' > ${samplename}_NM.txt
samtools view /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.bam | awk -F 'NM:i:' '{print $2}' | cut -f1 | sort | uniq -c | sort -k2,2n | awk '{print $2"\t"$1}' > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/NM37/${samplename}_NM.txt &&
echo 'all calculation done'

#q6 depth:
echo 'q6 Average depth of Ps genome?' >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt
len=5941411
less /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/2023_37HB/${samplename}.mapped_to_Pseudomonas.dd.q20.coverage.txt | awk  -v len=$len '{sum+=$3} END { print sum/len}' >> /SAN/ugi/plant_genom/jiajucui/answers2023_37HB/answers_for_${samplename}.txt &&
echo 'all calculation done'

