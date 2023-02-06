
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
#echo 'depth ref A C G T' > test.txt
paste depth nofdotref nofA nofC nofG nofT > test.txt
#filter out deletion and N
less test.txt| awk '{ if($2+$3+$4+$5+$6 == $1) print;}' > test2.txt
#1stmini and 2ndmini
#zero only ref
less test2.txt | awk '{ if($2 == $1) print;}' > coutzero1
less test2.txt | awk '{ if($2 == $1) print '0';}' > coutzero2
paste coutzero1 coutzero2 coutzero2 coutzero2 > coutzeroall

#with alt
less test2.txt | awk '{ if($2 != $1) print;}' | sed 's/[0]/999/g' | awk '{m=999; for (i=3; i<=NF; i++) if ($i < m) m = $i; print m}' > 1stmini



#generate all ref!=depth
less test2.txt | awk '{ if($2 != $1) print;}' > withaltall
paste withaltall 1stmini | awk '{ if($7 != '999') print;}' > withalt1stmin

#2ndmin=depth-ref-1stmin

less withalt1stmin | awk '{ print $1-$2-$7;}' > 2ndmin
less withalt1stmin | awk '{ print $7/$1;}' > 1stminfreq
paste withalt1stmin 2ndmin 1stminfreq> withaltcombined
#merge all
cat coutzeroall withaltcombined > ${samplename}_straincheck.txt

sed -i '1 i\depth ref A C G T 1stmin 2ndmin 1stminfreq' ${samplename}_straincheck.txt
