for line in $(cat ../samplenamelists/newsamplenames10.txt)
do

echo $line
#bash straincheckfinal.sh $line
#bash straincheckforR.sh $line
bash modified.sh $line
done
