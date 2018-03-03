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
      echo "-c param: ${OPTARG}"
      ;;
    w)
      WARNING_THRESHOLD=${OPTARG}
      echo "-w param: ${OPTARG}"
      ;;
    e)
      EMAIL=${OPTARG}
      echo "-e param: ${OPTARG}"
      ;;
  esac
done


if [[ -z ${CRITICAL_THRESHOLD+x} || -z ${WARNING_THRESHOLD+x} || -z ${EMAIL+x} || ${CRITICAL_THRESHOLD} -lt ${WARNING_THRESHOLD} ]]; then
  echo 'The following parameters are required: -c (critical threshold %) -w (warning threshold %)  -e (email address).  Critical threshold must always be greter than warning threshold.'
  exit
fi
