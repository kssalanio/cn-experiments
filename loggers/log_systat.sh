#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Illegal number of parameters, need 3:"
    echo "<EXPERIMENT_NAME>   <SLEEP_INTERVAL>   <EXPERIMENT_ITERATION>"
    exit 2
fi

EXPERIMENT_NAME=$1
SLEEP_INT=$3
ITR_NUM=$2

mem_stats () {
  local sleep_interval=$1
  echo "MEMORY USAGE          procs -----------memory----------  ---swap-- -----io---- -system-- ------cpu-----"
  echo "                      r  b   swpd   free   buff  cache    si   so    bi    bo   in   cs us sy id wa st"
  while true; do 
    time_ms=$(date +"%T.%3N")
    memstat=$(vmstat | sed -n '3 p')
    echo "vmstat> $time_ms $memstat"
    sleep $sleep_interval
  done
}

cpu_stats () {
  local sleep_interval=$1
  echo "CPU USAGE"
  echo "        TIME_MS      TIME         CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle"
  while true; do 
    time_ms=$(date +"%T.%3N")
    cpustat=$(mpstat | sed -n '4 p')
    echo "mpstat> $time_ms $cpustat"
    sleep $sleep_interval
  done
}

# Start measuring CPU
cpu_stats $SLEEP_INT > "{$EXPERIMENT_NAME}_CPU_{$ITR_NUM}.log" &
cpustat_pid=$!
echo "cpustat_pid: $cpustat_pid"

# Start measuring CPU
mem_stats $SLEEP_INT > "{$EXPERIMENT_NAME}_MEM_{$ITR_NUM}.log" &
memstat_pid=$!
echo "memstat_pid: $memstat_pid"


# run processes and store pids in array
# for i in $n_procs; do
#     ./procs[${i}] &
#     pids[${i}]=$!
# done


_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$cpustat_pid" 2>/dev/null
  kill -TERM "$memstat_pid" 2>/dev/null
}

echo "Hit CTRL+C to stop anytime"
echo "Logging System CPU and MEM usage..."
trap _term SIGTERM

# echo "Doing some initial work...";
# /bin/start/main/server --nodaemon &

# child=$! 
# wait "$child"

# wait for all pids
wait $cpustat_pid
wait $memstat_pid