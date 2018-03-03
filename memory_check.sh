#!/bin/bash

# Check your system's memory usage
# params: 
# -c critical treshold (percentage)
# -w warning treshold (percentage)
# -e email address to send report to

while getopts :c:w:e: opt; do
  case $opt in
    c)
      CRITICAL_THRESHOLD=${OPTARG}
      ;;
    w)
      WARNING_THRESHOLD=${OPTARG}
      ;;
    e)
      EMAIL=${OPTARG}
      ;;
  esac
done


if [[ -z ${CRITICAL_THRESHOLD+x} || -z ${WARNING_THRESHOLD+x} || -z ${EMAIL+x} || ${CRITICAL_THRESHOLD} -lt ${WARNING_THRESHOLD} ]]; then
  echo 'The following parameters are required: -c (critical threshold %) -w (warning threshold %)  -e (email address).  Critical threshold must always be greter than warning threshold.'
  exit
fi

USED_MEMORY=$( free | grep Mem: | awk '{ print $3}' )
TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2}' )

USED_PERCENTAGE=$(( ($USED_MEMORY*100)/$TOTAL_MEMORY ))


if [[ $USED_PERCENTAGE -ge $CRITICAL_THRESHOLD ]]; then
  PROCESS_FILE=/tmp/processlist.txt
  ps -eo pmem,pid,cmd > $PROCESS_FILE
  (head -n 1 $PROCESS_FILE && tail -n +2 $PROCESS_FILE | sort -k 1 -nr | head -n 10) > $PROCESS_FILE
  mail -s "$(date '+%Y%m%d %H:%M:%S') memory check - critical" ${EMAIL} < $PROCESS_FILE
  exit 2
fi

if [[ $USED_PERCENTAGE -ge $WARNING_THRESHOLD ]]; then
  exit 1
fi

if [[ $USED_PERCENTAGE -lt $WARNING_THRESHOLD ]]; then
  exit 0
fi
