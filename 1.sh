#!/bin/bash


function is_filter()
{

  local w="$1"
  local ret=0
  while read wf;do
    is_filter=$(echo "$w" | grep -F "$wf" | wc -l)
    if [ $is_filter -gt 0 ];then
      ret=1;
      break;
    fi
  done<<EOF
$(cat filter_word)
EOF
  return $ret;
}

function foo()
{
  local L=$1
  local c=$(echo "$L" | awk '{print $1}')
  local w=$(echo "$L" | awk '{print $4}' | awk -F'"' '{print $2}')
  local wc=$(echo "$w" | wc -m)

  if [ $wc -lt 3 ]; then
    return;
  fi

  is_filter "$w"
  if [ $? -ne 0 ]; then return; fi

  echo "INSERT INTO jrj_xwlb_word_daily(data_time,cn_word,cn_word_cnt) VALUES('$d', '$w', $c);" >> "tmp/${d}_1.sql"
}

if [ "X" != "X$2" ]; then
  d="$2"
else
  d=$(date -d '-1 days' +%Y-%m-%d)
fi

sql_cmd="mysql -ujrjdb -pjrjdb jrjdb --default-character-set=utf8 -A "

if [ ! -f "tmp/${d}_1.html" ]; then
  if [ "X" != "X$1" ]; then
    yes_url="$1"
  else
    yes_url=$(curl 'http://www.xinwenlianbo.net/' 2>/dev/null | grep -F  '新闻联播主要内容</a></h2>' | sed 's/"/\n/g' | grep html | grep http)
  fi

  curl "${yes_url}" > tmp/${d}_1.html
fi

if [ ! -f "tmp/${d}_2.html" ]; then
  wget -q --post-file="tmp/${d}_1.html"  'http://127.0.0.1:9200/_analyze?analyzer=ik&pretty=true' -O "tmp/${d}_2.html"
fi

echo "DELETE FROM jrj_xwlb_word_daily WHERE data_time = '$d';" > "tmp/${d}_1.sql"
cat "tmp/${d}_2.html"  | grep -B3 CN_WORD | grep token | sort | uniq -c | sort -rn | while read L ; do
  if [ "X" = "X$L" ];then continue; fi
  foo "$L"
done

sql="source tmp/${d}_1.sql;"
$sql_cmd -e "$sql"



