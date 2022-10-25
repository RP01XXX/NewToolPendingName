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
nmap -sP  $IP -oG - | grep Host | cut -d' ' -f 2 | sort -u > "/$path/Nmap-$Name/PingSweep.txt"

#run a complete scan to parse data.
nmap -A -O -Pn -p- -iL "/$path/Nmap-$Name/NmapAliveIPs.txt" -oA  "/$path/Nmap-$Name/NmapIPAll.txt"

#Resolve the IP range to Hostnames
dnsrecon -r $IP -t rvl -c "path/Nmap-$Name/Hostnames.txt"

#You are now set to run https://raw.githubusercontent.com/jasonjfrank/gnmap-parser/master/Gnmap-Parser.sh
chmod 777 $path/Nmap-$Name
chmod 777 $path/Nmap-$Name/*
