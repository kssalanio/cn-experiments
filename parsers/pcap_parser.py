
import dpkt
import socket
import argparse

parser = argparse.ArgumentParser(description='pcap file')
parser.add_argument('pcap_file', type=str,
                    help='pcap file location')
parser.add_argument('remote_addr', type=str,
                    help='remote address')
args = parser.parse_args()
#REMOTE_ADDR = "202.90.159.172"
REMOTE_ADDR = args.remote_addr
# with dpkt.pcap.Reader(open(args.pcap_file,'rb')) as pcap_fh:
counter=0
ipcounter=0
tcpcounter=0
udpcounter=0
# for ts, pkt in pcap_fh:
ts_now = None
ts_prev = None
iat_max = 0
iat_min = 999999
iat_sum = 0.0
iat_count = 0
for ts, pkt in dpkt.pcap.Reader(open(args.pcap_file,'rb')):

    counter+=1
    # print(f"{len(pkt)}")
    eth=dpkt.ethernet.Ethernet(pkt) 
    if eth.type!=dpkt.ethernet.ETH_TYPE_IP:
        continue

    ip=eth.data
    ipcounter+=1

    if ip.p==dpkt.ip.IP_PROTO_TCP: 
        tcpcounter+=1

    if ip.p==dpkt.ip.IP_PROTO_UDP:
        udpcounter+=1

    #NOTE: interarrival calculation
    if socket.inet_ntoa(ip.src) == REMOTE_ADDR: # Filter packets arriving from remote source
        iat_count +=1
        if ts_now is None:
            ts_now = ts
        else:
            ts_prev = ts_now
            ts_now = ts
            iat = (ts_now - ts_prev)*1000.00
            # if iat > 1.0:
            #     print(f"IAT:{iat}")
            #     print(f"{socket.inet_ntoa(ip.src)}")
            iat_sum += iat
            if iat_min > iat:
                iat_min = iat
            if iat_max < iat:
                iat_max = iat

print(f"Total number of packets in the pcap file: {counter}")
print(f"Total number of ip packets: {ipcounter}")
print(f"Total number of tcp packets: {tcpcounter}")
print(f"Total number of udp packets: {udpcounter}" )
print(f"===INTERARRIVAL TIMES===")
iat_avg = iat_sum / iat_count
print(f"Packet IATs   : {iat_count} IATs" )
print(f"Packet IAT avg: {iat_avg} ms" )
print(f"Packet IAT min: {iat_min} ms" )
print(f"Packet IAT max: {iat_max} ms" )
