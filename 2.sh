#!/bin/bash

shellLocation=`dirname $0`
shellLocation=`cd "$shellLocation" ; pwd`

source ~/.bashrc

d=$(date "+%Y-%m-%d")
log_path='tmp/'
rand=$(date +%Y%m%d%H%M%S.%s.%N)

stock_code="0000001"
k_type="day"
stock_code_163="${stock_code}"

sql_cmd="mysql -ujrjdb -pjrjdb jrjdb --default-character-set=utf8 -A "

## 上证指数
hh_file="${log_path}/szzs.txt.$d"
if [ ! -f "$hh_file" ];then
  curl "http://img1.money.126.net/data/hs/kline/${k_type}/history/$(date +%Y)/${stock_code_163}.json?callback=" > ${hh_file} 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "curl return err $?"
    exit 1
  fi
fi

sql_file="${log_path}/szzs.sql"
cat /dev/null >"${sql_file}"
./2.js "$hh_file" |tail -5| awk '{printf("REPLACE INTO jrj_xwlb_szzs_dayk (data_time,open_value,close_value,high_value,low_value,cnt_value,range_value) values(\x27%s\x27,%s,%s,%s,%s,%s,%s);\n",$1,$2,$3,$4,$5,$6,$7);}' >>"${sql_file}"

sql="source ${sql_file};"
$sql_cmd -e "$sql"

sql="select min(range_value),0.5*min(range_value),0,0.5*max(range_value),max(range_value) from jrj_xwlb_szzs_dayk;"
range=$($sql_cmd -N -e "$sql")
echo "score range:$range"
rmin=$(echo "$range" | awk '{print $1}')
rmin5=$(echo "$range" | awk '{print $2}')
rmid=$(echo "$range" | awk '{print $3}')
rmax5=$(echo "$range" | awk '{print $4}')
rmax=$(echo "$range" | awk '{print $5}')

cat /dev/null >"${sql_file}"
./2.js "$hh_file" |tail -1| awk -v rmin=$rmin -v rmin5=$rmin5 -v rmid=$rmid -v rmax5=$rmax5 -v rmax=$rmax '{
  if ($7 == 0) ss=50;
  else if($7 > 0) ss=(1+$7/rmax)*50;
  else if($7 < 0) ss=(1-$7/rmin)*50;
  else ss=50;
  printf("REPLACE INTO jrj_xwlb_szzs_score (data_time,score) values(\x27%s\x27, %s);\n", $1, ss);
}' >"${sql_file}"
sql="source ${sql_file};"
$sql_cmd -e "$sql"


exit 0

