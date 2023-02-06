
#generate the table script:
samplename=${1}
refPs=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_Ps/Pseudomonas.OTU5_ref.fasta

samtools mpileup -f ${refPs} /SAN/ugi/plant_genom/jiajucui/4_mapping_to_pseudomonas/strainscheck/${samplename}_removalAt_mapped_to_ps.sorted.q20.bam > pileupfile
#depth
less pileupfile | awk '{ if($4 != "1") print;}' | awk '{ if($4 != "0") print;}' | awk '{print $4}' > depth

#ref and ACGT
less pileupfile | awk '{ if($4 != "1") print;}' | awk '{ if($4 != "0") print;}' | awk '{print $5}' | sed 's/[^.,]//g' | awk '{ print length}'|tr ' ' '\n' > nofdotref

less pileupfile | awk '{ if($4 != "1") print;}' | awk '{ if($4 != "0") print;}' |  awk '{print $5}' | sed 's/[^Aa]//g' | awk '{ print length}'|tr ' ' '\n' > nofA

less pileupfile | awk '{ if($4 != "1") print;}' | awk '{ if($4 != "0") print;}' |  awk '{print $5}' | sed 's/[^Cc]//g' | awk '{ print length}'|tr ' ' '\n' > nofC

less pileupfile |less | awk '{ if($4 != "1") print;}' | awk '{ if($4 != "0") print;}' | awk '{print $5}' | sed 's/[^Gg]//g' | awk '{ print length}'|tr ' ' '\n'> nofG

less pileupfile | less | awk '{ if($4 != "1") print;}' | awk '{ if($4 != "0") print;}' | awk '{print $5}' | sed 's/[^Tt]//g' | awk '{ print length}'|tr ' ' '\n' > nofT
#table
echo 'depth ref A C G T' > ${samplename}_straincheckforR.txt
##filter out deletion and N
paste depth nofdotref nofA nofC nofG nofT | awk '{ if($2+$3+$4+$5+$6 == $1) print;}' >> ${samplename}_straincheckforR.txt
