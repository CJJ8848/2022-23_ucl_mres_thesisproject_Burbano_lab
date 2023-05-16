#!/bin/bash -l

#$ -l tmem=10G
#$ -l h_vmem=10G
#$ -l h_rt=30:00:0
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
r1=/SAN/ugi/plant_genom/jiajucui/2_trimmed_merged/trim143/${samplename}.pair1.truncated.gz
r2=/SAN/ugi/plant_genom/jiajucui/2_trimmed_merged/trim143/${samplename}.pair2.truncated.gz


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

#use samtools merge to combine sam from collapsed sai and sam merged after algin to both fastq reads
#-n means sort by read name
samtools merge -n /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.combined_At.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.r1r2_At.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.collapsed_At.sorted.bam
#need to be sorted again
samtools sort -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.combined_At.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.combined_At.bam &&
echo 'samtools cat combine done' &&

samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.combined_At.sorted.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_Atsam_flagstats.log 



echo "q1 What is the percentage of A.theliana DNA?" >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
echo "base in total:" >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
grep 'in total' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_Atsam_flagstats.log  >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt

#convert mapped reads into bam with map quality score greater than 80 
#-b means output format is bam, -h means write the header
samtools view -@ 2 -F 4 -q 20 -bh -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_mapped_At.q20.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.combined_At.sorted.bam
#flagstat for q1 What is the percentage of A.theliana DNA?
samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_mapped_At.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_At_flagstats.q20.log 
echo "base mapped to At:" >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_At_flagstats.q20.log >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt


####################
#q2 What is the percentage of Pseudomonas DNA? after removing mapped reads to A.theliana
###method 1
#-b means the output format is bam, -f means only keep the unmapped reads
samtools view -bf 4 /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}.combined_At.sorted.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_after_removal_mappedAt.bam

#sort it 

samtools sort -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_after_removal_mappedAt.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_after_removal_mappedAt.bam
##use bwa to realign the unmapped bam file
bwa aln -t 2 -l 1024 ${refPs} -b /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_after_removal_mappedAt.sorted.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_realign.sorted.sai

##sai to sam
bwa samse -f /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sam ${refPs} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_realign.sorted.sai /SAN/ugi/plant_genom/jiajucui/4_mapping_to_A_theliana/trim143/${samplename}_after_removal_mappedAt.sorted.bam

#Keep the mapped reads and create a compressed BAM file using samtools -S means the input format is sam
samtools view -@ 2 -F 4 -Sbh -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sam

#Sort the BAM file by chromosome and position using samtools
samtools sort -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sorted.bam /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.bam
#q20
samtools view -q 20 /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sorted.bam -o /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam

samtools flagstat /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_Ps_flagstats.q20.log
#output
echo "q2 What is the percentage of Pseudomonas DNA after removing mapped reads to A.theliana?" >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
echo "base mapped to Pseudomonas after removing:" >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
grep 'mapped (' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_Ps_flagstats.q20.log >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt

#get the number of base mapped to pseudomonas
#q3 What is the percentage that remains unannotated?
echo 'q3 What is the percentage that remains unannotated?' >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
#q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?
echo 'q4 What is the percentage of the Pseudomonas genome that is covered by at least 1 read?' >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
#coverage
samtools depth -aa  /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt
echo 'pseudomonas bases in total:' >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
wc -l /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt | cut -d ' ' -f 1 >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
#5941411
echo 'bases with at least 1 read:' >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
awk '($3 >= 1) {count++} END {print count}' /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
#872665
#q5 What is the distribution of edit distances? Distribution of edit distances - Histograms
#echo 'NM:' > ${samplename}_NM.txt
samtools view /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam | awk -F 'NM:i:' '{print $2}' | cut -f1 | sort | uniq -c | sort -k2,2n | awk '{print $2"\t"$1}' > /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/NM143/${samplename}_NM.txt 
#q6 depth:
echo 'q6 Average depth of Ps genome?' >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt
len=5941411
less /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/trim143/${samplename}.mapped_to_Pseudomonas.coverage.q20.txt | awk  -v len=$len '{sum+=$3} END { print sum/len}' >> /SAN/ugi/plant_genom/jiajucui/trim143answers/answers_for_${samplename}.txt &&
echo 'all calculation done'

