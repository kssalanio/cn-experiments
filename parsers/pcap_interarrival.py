import dpkt
# import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt

f = open('packetcapture.pcap','rb')

pcap = dpkt.pcap.Reader(f)

pktLengths = []         # Python list of packet lengths, one for each packet
pktInterarrivals = []   # Python list of packet inter-arrival times, one for each packet after the first
first = True            # flag to indicate the first packet in the pcap file
for ts, pkt in pcap:
    # Obtain packet length and append value to pktLengths list
    #

    # Calculate packet inter-arrival time starting with second packet
    # and append to pktInterarrivals list
    #

    first = False   # After first packet, clear the first packet flag
    last = ts       # Save timestamp of previous packet for inter-arrival time calculation

# Turn Python lists into Numpy arrays, print descriptive statistics, and plot distributions
#
pktLen = np.array(pktLengths)
print("Minimum packet length: "+str(np.min(pktLen)))
print("Average packet length: "+str(np.average(pktLen)))
print("Maximum packet length: "+str(np.max(pktLen)))
# sns.kdeplot(pktLen)
plt.show()

pktArrival = np.array(pktInterarrivals)
print("Minimum packet inter-arrival: "+str(np.min(pktArrival)))
print("Average packet inter-arrival: "+str(np.average(pktArrival)))
print("Maximum packet inter-arrival: "+str(np.max(pktArrival)))
# sns.kdeplot(pktArrival)
plt.show()