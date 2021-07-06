#!/bin/bash
###
#
# USAGE: ./tcpdump_to_pcap.sh > test_dump.log
#
###
INF="eno1"  # interface target for pcap
PCAP_FILE="./test_dump.pcap"    # pcap dump fule
CLIENT="root@10.158.47.150" # remote client for flows
#HOST=202.90.159.172 # preginet
HOST=168.119.138.211 # openwrt

cpu_stats () {
  local sleep_interval=$1
  echo "        TIME_MS      TIME         CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle"
  while true; do 
    time_ms=$(date +"%T.%3N")
    cpustat=$(mpstat | sed -n '4 p')
    echo "mpstat> $time_ms $cpustat"
    sleep $sleep_interval
  done
}

# Start measuring CPU
cpu_stats 0.25 &
loop_pid=$!
echo "lpid: $loop_pid"


# Fork a tcpdump
tcpdump -i $INF -s 65535 -w $PCAP_FILE host $HOST &

# Get tcpdump PID
child_pid=$!
parent_pid=$$
echo "cpid: $child_pid"
echo "ppid: $parent_pid"



# Start TCP flow/s here
sleep 1
DATE_NS=$(date +%s%N)
DATE_MS=$(date +"%T.%3N")
echo "Start time: $DATE_NS   $DATE_MS"
#ssh $CLIENT 'wget -c http://mirror.pregi.net/ubuntu-releases/20.04.2.0/ubuntu-20.04.2.0-desktop-amd64.iso.zsync'
#ssh $CLIENT 'wget -c https://downloads.openwrt.org/releases/19.07.7/targets/x86/64/openwrt-sdk-19.07.7-x86-64_gcc-7.5.0_musl.Linux-x86_64.tar.xz'
wget -c https://downloads.openwrt.org/releases/19.07.7/targets/x86/64/openwrt-sdk-19.07.7-x86-64_gcc-7.5.0_musl.Linux-x86_64.tar.xz
DATE_NS=$(date +%s%N)
DATE_MS=$(date +"%T.%3N")
echo "End time: $DATE_NS   $DATE_MS"

# Kill tcpdump child process and cpu metric loop
kill -2 $child_pid
sleep 1
kill -9 $loop_pid
