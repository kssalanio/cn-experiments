#!/bin/bash

#IPERF_SERVER="2404:b940:10:101:C0:A801:0100::"
IPERF_SERVER="2404:b940:10:101:C0:A802:0100::"
SLEEP_INT=90
IPERF_TIME=13
IPERF_OMIT=3
LENGTH=1400
WINDOW=2048
echo "Timestamp     bps    PFlow  [ ID]   Interval       Transfer     Bitrate         Jitter    Lost/Total Datagrams"
#for PFLOWS in 15 20 25
#for PFLOWS in 5 10 15 20 25
for PFLOWS in $(seq 10 10 100)
do
#  for MBPS in 1 5 10 15 20
  for MBPS in 10.00 11.11 12.50 14.29 16.67 20.00 25.00 33.33 50.00 100.00
  do
    # iperfout=$(iperf3 -c ${IPERF_SERVER} -i 1 -b${MBPS}M -P${PFLOWS} -t $IPERF_TIME -O $IPERF_OMIT  -l$LENGTH -w$WINDOW -u | tail -n 3 | head -n1) #UDP
    #iperfout=$(iperf3 -c ${IPERF_SERVER} -i 1 -b${MBPS}M -P${PFLOWS} -t $IPERF_TIME -O $IPERF_OMIT  -l$LENGTH -w$WINDOW| tail -n 3 | head -n1) #TCP
    iperfout=$(iperf3 -c ${IPERF_SERVER} -i 1 -b${MBPS}M -P${PFLOWS} -t $IPERF_TIME -O $IPERF_OMIT  -l$LENGTH -w$WINDOW --timestamp='%Y-%m-%d-%H:%M:%S ') #TCP
    echo "$iperfout"
    timestamp=$(date +"%T.%3N")
    iperf_sum=$(echo "$iperfout" | tail -n 3 | head -n1)
    echo "${timestamp}  $MBPS     $PFLOWS    $iperf_sum"
    sleep $SLEEP_INT
#    printf '%s  %05d     %05d    %s' $timestamp $MPBS $PFLOWS $iperfout
#    echo ${MBPS}M $PFLOWS

  done
done