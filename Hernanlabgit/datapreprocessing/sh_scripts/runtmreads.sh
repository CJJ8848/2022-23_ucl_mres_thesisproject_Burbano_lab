
echo 'samplename dist_tmreads'  > tmreads.txt
for line in $(cat newsamplenames.txt)
do

bash tmreads.sh $line >> tmreads.txt
done

