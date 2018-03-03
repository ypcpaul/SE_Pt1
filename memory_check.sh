#!/bin/bash

# Check your system's memory usage
# params: 
# -c critical treshold (percentage)
# -w warning treshold (percentage)
# -e email address to send report to

while getopts :c:w:e: opt; do
  case $opt in
    c)
      CRITICALTHRESHOLD=${OPTARG}
      echo "-c param: ${OPTARG}"
      ;;
    w)
      WARNINGTHRESHOLD=${OPTARG}
      echo "-w param: ${OPTARG}"
      ;;
    e)
      EMAIL=${OPTARG}
      echo "-e param: ${OPTARG}"
      ;;
  esac
done

if [[ -z ${CRITICALTHRESHOLD+x} || -z ${WARNINGTHRESHOLD+x} || -z ${EMAIL+x} ]]; then
  echo 'The following parameters are required: -c (critical threshold %) -w (warning threshold %)  -e (email address)'
  exit
fi
