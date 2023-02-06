echo 'samplename At_percent Ps_percent unannotated Ps_atleast1read average_depth'  >> allwithq20combined_143allqaforplot.txt

for line in $(cat newsamplenames.txt);
do
bash plotdatagenerate.sh $line >> allwithq20combined_143allqaforplot.txt;
done

