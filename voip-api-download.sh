#!/bin/bash
year=`date +%Y`
month=`date +%m`
day=`date +%d`

curl -d '{"jsonrpc":"2.0","id":"38185","method":"get.calls_report","params":{"access_token":"???","date_from":"'${year}'-'${month}'-'${day}' 00:00:00","date_till":"'${year}'-'${month}'-'${day}' 23:59:59","fields":["call_records","id","start_time","direction","contact_phone_number"]}}' -H "Content-Type: application/json" https://dataapi.voipprovider.ru/v2.0 > /home/record/voipprovider.log
sed -i 's/{/\r\n/g' /home/record/voipprovider.log
cat voipprovider.log | grep -v '\[\]' | grep $year > voipprovider-formatted.log
sed -i 's/]//g' /home/record/voipprovider-formatted.log

mkdir /home/record/recordings/$year
mkdir /home/record/recordings/$year/$month
mkdir /home/record/recordings/$year/$month/$day

while read -r LINE; do
max=`echo $LINE | grep -o , | wc -l`

for count in `seq 1 $max`;
 do
data=`echo $LINE | cut -d ',' -f$count`
split=`echo $data | cut -d : -f1 | sed s/[^0-9,a-z]//g;`
[ $split == "direction" ] && direction=`echo $data | cut -d ':' -f2 | sed s/[^0-9,a-z]//g;`
[ $split == "callrecords" ] && callrecords=`echo $data | cut -d ':' -f2 | sed s/[^0-9,a-z]//g;`
[ $split == "starttime" ] && starttime=`echo $data | cut -d '"' -f4 | sed s/[^0-9,a-z]//g;`
[ $split == "id" ] && id=`echo $data | cut -d ':' -f2 | sed s/[^0-9,a-z]//g;`
[ $split == "contactphonenumber" ] && contactphonenumber=`echo $data | cut -d ':' -f2 | sed s/[^0-9,a-z]//g;`
[ $(expr length $split) -eq 32 ] && transfered=$split
done

wget http://app.voipprovider.ru/system/media/talk/${id}/${callrecords}/ -O /home/record/recordings/$year/$month/$day/${starttime}-${direction}-${contactphonenumber}-${id}-${callrecords}.mp3
[ -n "${transfered}" ] && wget http://app.voipprovider.ru/system/media/talk/${id}/${callrecords}/ -O /home/record/recordings/$year/$month/$day/${starttime}-${direction}-${contactphonenumber}-${id}-${transfered}.mp3
transfered=

done < /home/record/voipprovider-formatted.log

mount /media/strorage
mkdir /media/strorage/recordings/$year
mkdir /media/strorage/recordings/$year/$month
mkdir /media/strorage/recordings/$year/$month/$day
cp -v /home/record/recordings/$year/$month/$day/* /media/strorage/recordings/$year/$month/$day/

logs=`cat voipprovider.log | grep -v '\[\]' | grep $year | wc -l`
files=`ls /media/strorage/recordings/$year/$month/$day/ | wc -l`
status="PROBLEM"
[ $files -ge $logs ] &&  status="OK"
echo ${status}: $logs records found, $files files downloaded
