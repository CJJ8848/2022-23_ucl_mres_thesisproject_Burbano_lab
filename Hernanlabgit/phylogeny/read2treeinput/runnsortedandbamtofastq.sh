#for line in $(cat oldsamplenames7.txt)
for line in $(cat newsamplenames10.txt)
do

echo $line
bash nsortedandbamtofastq.sh $line

done
