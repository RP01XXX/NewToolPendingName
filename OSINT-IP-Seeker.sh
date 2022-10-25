#!/bin/bash
#This section runs NMAP scans of all IPs provided with a ping scan first then adds to an IP listing, then it finds specific ports of interest and then runs a complet scan as well.
echo "Enter Your IP"
read IP

echo "Company Name"
read Name

echo "Path to save folder"
read path

cd $HOME
if [ ! -d "$path/Nmap-$Name" ];then
    mkdir "$path/Nmap-$Name" 
fi

# Perform a Ping Scan
nmap -sP  $IP -oA - | grep Host | cut -d' ' -f 2 | sort -u > "/$path/Nmap-$Name/PingSweep.txt"

#run a complete scan to parse data.
nmap -A -O -Pn -p- -iL "/$path/Nmap-$Name/NmapAliveIPs.txt" -oA  "/$path/Nmap-$Name/NmapIPAll.txt"

#Needs NMAP Parser added
chmod 777 $path/Nmap-$Name
chmod 777 $path/Nmap-$Name/*
