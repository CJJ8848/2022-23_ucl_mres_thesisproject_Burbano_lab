#!/bin/bash -l

#$ -l tmem=3G
#$ -l h_vmem=3G
#$ -l h_rt=30:00:0
#$ -wd /SAN/ugi/plant_genom/jiajucui/
#$ -V
#$ -e /SAN/ugi/plant_genom/jiajucui/logs/
#$ -o /SAN/ugi/plant_genom/jiajucui/logs/

#variables
i=${1}
samplename=$(cat new_sampleindex.txt | sed -n $i'p' | awk '{print $2}')
echo "${samplename}:" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
refAt=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_At/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
refPs=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_Ps/Pseudomonas.OTU5_ref.fasta
r1=/SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/${samplename}.R1.fastq.gz
r2=/SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/${samplename}.R2.fastq.gz
r1afterremoval=/SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/afterremoveAt/${samplename}.R1.unmappedAt.fastq.gz
r2afterremoval=/SAN/ugi/plant_genom/jiajucui/1_initial_data/new_sequences/afterremoveAt/${samplename}.R2.unmappedAt.fastq.gz

#collapse_At.sam is from collapsed sai
#r1r2_At.sam is merged from r1.sai and r2.sai
#combined_At.sam is combined from the above two sam files
bwa aln -t 2 -l 1024 -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1.collapsed.sai ${refAt} ${r1} &&
echo 'bwa aln r1 done' &&
bwa aln -t 2 -l 1024 -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r2.collapsed.sai ${refAt} ${r2} &&
echo 'bwa aln r2 done' &&
# Convert  reads into a standard alignment format (SAM)
bwa sampe -r @RG\\tID:${samplename}\\tSM:${samplename} -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.sam ${refAt} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1.collapsed.sai /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r2.collapsed.sai ${r1} ${r2} &&
echo 'bwa sampe done' &&
#create a compressed BAM file using samtools
samtools view -b -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.sam
#sort the BAM file by chromosome and position using samtools
samtools sort -n -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.bam &&
echo 'samtobam and sort done for two' &&

#for restore
rm /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.sam &&
echo 'rm r1r2.sam' &&


#generate the index

samtools index /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.sorted.bam

samtools index /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.collapsed_At.sorted.bam


#use samtools merge to combine sam from collapsed sai and sam merged after algin to both fastq reads
#-n means sort by read name
samtools merge -n /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.combined_At.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.r1r2_At.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.collapsed_At.sorted.bam
#need to be sorted again
samtools sort -n -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.combined_At.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.combined_At.bam &&
echo 'samtools cat combine done' &&

samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.combined_At.sorted.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_Atsam_flagstats.log 



echo "q1 What is the percentage of A.theliana DNA?" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
echo "base in total:" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
grep 'in total' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_Atsam_flagstats.log  >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt

#convert mapped reads into bam with map quality score greater than 80 
samtools view -@ 2 -F 4 -q 20 -Sbh -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_mapped_At.q20.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.combined_At.sorted.bam
#flagstat for q1 What is the percentage of A.theliana DNA?
samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_mapped_At.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_At_flagstats.q20.log 
echo "base mapped to At:" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_At_flagstats.q20.log >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt


####################
#q2 What is the percentage of Pseudomonas DNA? after removing mapped reads to A.theliana
###method 1
samtools view -f 4 /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}.combined_At.sorted.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_after_removal_mappedAt.bam

##use bwa to realign the unmapped bam file
bwa aln -t 2 -l 1024 ${refPs} -b /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_after_removal_mappedAt.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_realign.sai

##sai to sam
bwa samse -r @RG\\tID:${samplename}\\tSM:${samplename} -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sam ${refPs} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_realign.sai /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/${samplename}_after_removal_mappedAt.bam

#Keep the mapped reads and create a compressed BAM file using samtools
samtools view -@ 2 -F 4 -Sbh -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sam

#Sort the BAM file by chromosome and position using samtools
samtools sort -n -@ 2 -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.bam
#q20
samtools view -q 20 /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sorted.bam -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam

samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_Ps_flagstats.q20.log
#output
echo "q2 What is the percentage of Pseudomonas DNA after removing mapped reads to A.theliana?" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
echo "base mapped to Pseudomonas after removing:" >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_Ps_flagstats.q20.log >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt

#get the number of base mapped to pseudomonas
#q3 What is the percentage that remains unannotated?
echo 'q3 What is the percentage that remains unannotated?' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?
echo 'q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#coverage
samtools depth -aa  /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt
echo 'pseudomonas bases in total:' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
wc -l /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt | cut -d ' ' -f 1 >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#5941411
echo 'bases with at least 1 read:' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
awk '($3 >= 1) {count++} END {print count}' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
#872665
#q5 What is the distribution of edit distances? Distribution of edit distances - Histograms
#echo 'NM:' > ${samplename}_NM.txt
samtools view /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam | awk -F 'NM:i:' '{print $2}' | cut -f1 | sort | uniq -c | sort -k2,2n | awk '{print $2"\t"$1}' > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/NM_readlength/${samplename}_NM.txt 
#q6 depth:
echo 'q6 Average depth of Ps genome?' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt
len=5941411
less /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt | awk  -v len=$len '{sum+=$3} END { print sum/len}' >> /SAN/ugi/plant_genom/jiajucui/answers_for_${samplename}.txt &&
echo 'all calculation done'

