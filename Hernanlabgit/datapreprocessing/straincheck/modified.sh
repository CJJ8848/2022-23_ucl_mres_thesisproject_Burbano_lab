samplename=${1}
refPs=/SAN/ugi/plant_genom/jiajucui/1_initial_data/reference_genome_Ps/Pseudomonas.OTU5_ref.fasta

less ${samplename}_straincheck.txt | awk '{ if('0.5'<$9 && $9<'1') print '1'-$9;}' > modifiedfreq1
less ${samplename}_straincheck.txt | awk '{ if('0.5'<$9 && $9<'1') print;}' > all1
paste all1 modifiedfreq1 > combined1
less ${samplename}_straincheck.txt | awk '{ if($9=='1' || $9<='0.5') print $9;}' > modifiedfreq2
less ${samplename}_straincheck.txt | awk '{ if($9=='1' || $9<='0.5') print;}' > all2
paste all2 modifiedfreq2 > combined2
cat combined1 combined2 > ${samplename}_straincheckmodified.txt
sed -i '1 i\depth ref A C G T 1stmin 2ndmin 1stminfreq modifiedfreq' ${samplename}_straincheckmodified.txt

gzip ${samplename}_straincheckmodified.txt
